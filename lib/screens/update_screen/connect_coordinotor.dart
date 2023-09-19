import 'dart:convert';
import 'dart:async';

import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proximity_sensor/proximity_sensor.dart';

import '../../providers/query_provider.dart';

const APP_ID = "20971648246c496fa6e2a8856c4e0d1e";
class NoCoordinator extends StatefulWidget {
  const NoCoordinator({super.key, this.phoneNumber, this.callToken});
  final String? phoneNumber;
  final String? callToken;
  @override
  _NoCoordinatorState createState() => _NoCoordinatorState();
}

class _NoCoordinatorState extends State<NoCoordinator> {
  bool _isSpeakerOn = false;
  bool _isMuted = false;
  bool _isCallActive = false;
  Duration _callDuration = Duration.zero;
  late QueryProvider provider;
  late RtcEngine? _engine;
  late String callToken;
  String callState = "";
  bool _enableInEarMonitoring = false;
  double _inEarMonitoringVolume = 100;
  bool _isNear = false;
  late StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    callToken = idGenerator();
    provider = Get.put(QueryProvider());
    // listenSensor();

    initiateCall();
    _toggleScreenOnOff();
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    leaveChannel();
    _streamSubscription.cancel();
  }

  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
      });
    });
  }

  void initiateCall() async {
    // Loaders.loadingDialog(title: "Calling Support");
    if(widget.callToken != null ){
      callToken = widget.callToken!;
      initializeAgora();
      return;
    }
    try{
      callState = "Finding Available HCF";
      bool res = await provider.placeCall(callToken, userId: widget.phoneNumber, type: "connect");
      if(!res){
        Loaders.errorDialog("It seems that all our HCF is busy at the moment. Please Call back again after sometime.", title: "Call Could not be placed",);
      }
      initializeAgora();
      return;
    }catch(e){
      print(e);
    }
    callState = "No Available HCF";
  }

  String idGenerator() {
    final now = DateTime.now();
    return now.microsecondsSinceEpoch.toString();
  }

  Future<void> initializeAgora() async {
    await [Permission.microphone].request();
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(
      appId: APP_ID,
    ));
    await _engine!.setLogLevel(LogLevel.logLevelNone);
    _engine!.registerEventHandler(
      RtcEngineEventHandler(
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            debugPrint("local user ${connection.localUid} joined");
            setState(() {
              callState = "Connecting...";
            });
          },
          onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
            debugPrint("remote user $remoteUid joined");
            setState(() {
              callState = "Connected";
            });
            _startCallTimer();
          },
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) async {
            debugPrint("remote user $remoteUid left channel");
            // setState(() {
            //   callState = "Reconnecting";
            // });
            _startCallTimer();
            await leaveChannel();
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          },
          onError: (ErrorCodeType codeType, message){
            debugPrint("$codeType : $message");
            _startCallTimer();
          },
          onFacePositionChanged: (int imageWidth, int imageHeight, List<Rectangle> vecRectangle,
              List<int> vecDistance, int numFaces){
            print(vecDistance);
            Logger().d(vecDistance[0]);
          }

      ),
    );
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableAudio();
    await _engine!.setDefaultAudioRouteToSpeakerphone(false);
    // await _engine!.
    await joinChannel();
  }

  Future<void> joinChannel() async {
    await _engine!.joinChannel(channelId: callToken, token: APP_ID, uid: 0, options: const ChannelMediaOptions() );
    // _startCallTimer();
  }

  Future<void> leaveChannel({bool calledFromDispose = false}) async {
    setState(() {
      callState = "Disconnected";
    });
    try{
      bool res = await provider.placeCall(callToken, userId: widget.phoneNumber, type: 'disconnect');
    }catch(e){
      Logger().e(e);
    }
    await disposeAgora();
    if(!calledFromDispose){
      await Get.offAllNamed('/home');
    }
    // _startCallTimer();
  }

  Future<void> disposeAgora() async {
    if(_engine != null){
      await _engine!.leaveChannel();
      await _engine!.release();
    }

  }


  void _startCallTimer() {
    const oneSecond = Duration(seconds: 1);
    Future.delayed(oneSecond, () {
      setState(() {
        if(callState == "Connected"){
        _callDuration = _callDuration + oneSecond;
          _startCallTimer();
        }
      });
    });
  }

  void _toggleSpeaker() async{
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
    await _engine!.setEnableSpeakerphone(_isSpeakerOn);
  }

  void _toggleMute() async{
    setState(() {
      _isMuted = !_isMuted;
    });
    await _engine!.muteLocalAudioStream(_isMuted);
  }

  void _hangUp() async{
    setState(() {
      _isCallActive = false;
    });
    await leaveChannel();
    await Future.delayed(const Duration(seconds: 2));
    Get.offAndToNamed('/home');
  }

  _onChangeInEarMonitoringVolume(double value) async {
    _inEarMonitoringVolume = value;
    await _engine!.setInEarMonitoringVolume(_inEarMonitoringVolume.toInt());
    setState(() {});
  }

  _toggleInEarMonitoring(value) async {
    _enableInEarMonitoring = value;
    await _engine!.enableInEarMonitoring(enabled: _enableInEarMonitoring, includeAudioFilters: EarMonitoringFilterType.earMonitoringFilterNoiseSuppression);
    setState(() {});
  }

  _toggleScreenOnOff() async{
    await _engine!.enableFaceDetection(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Support Call",
        backFunction: () async{
          try{
            await disposeAgora();
          }catch(e){
            print(e);
          }
          Get.back();
        },
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/icons/appstore.png'), // Replace with your image
                radius: 60,
              ),
              const SizedBox(height: 20),
              const Text(
                'HCF Support',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                '${callState}',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'Call duration: ${_callDuration.inMinutes}:${_callDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: _isSpeakerOn ? const Icon(Icons.volume_up): const Icon(Icons.volume_off, ),
                    onPressed: _toggleSpeaker,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: _isMuted ? const Icon( Icons.mic_off) : const Icon(Icons.mic),
                    onPressed: _toggleMute,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: const Icon(Icons.call_end, color: Colors.redAccent,),
                    onPressed: _hangUp,
                  ),
                  // IconButton(
                  //   icon: const Icon(Icons.call_end, color: Colors.redAccent,),
                  //   onPressed: ()async{
                  //
                  //     // print(await d.getRecordingDevice());
                  //   },
                  // ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}