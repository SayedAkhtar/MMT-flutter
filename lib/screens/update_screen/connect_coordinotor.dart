import 'dart:convert';
import 'dart:async';

import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../providers/query_provider.dart';

// class NoCoordinator extends StatefulWidget {
//   const NoCoordinator({super.key});
//
//   @override
//   State<StatefulWidget> createState() {
//     return NoCoordinatorState();
//   }
// }
//
// class NoCoordinatorState extends State<NoCoordinator> {
//   late CallKitParams? calling;
//
//   Timer? _timer;
//   int _start = 0;
//
//   void startTimer() {
//     const oneSec = Duration(seconds: 1);
//     _timer = Timer.periodic(
//       oneSec,
//           (Timer timer) {
//         setState(() {
//           _start++;
//         });
//       },
//     );
//   }
//
//   String intToTimeLeft(int value) {
//     int h, m, s;
//     h = value ~/ 3600;
//     m = ((value - h * 3600)) ~/ 60;
//     s = value - (h * 3600) - (m * 60);
//     String hourLeft = h.toString().length < 2 ? '0$h' : h.toString();
//     String minuteLeft = m.toString().length < 2 ? '0$m' : m.toString();
//     String secondsLeft = s.toString().length < 2 ? '0$s' : s.toString();
//     String result = "$hourLeft:$minuteLeft:$secondsLeft";
//     return result;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     var timeDisplay = intToTimeLeft(_start);
//
//     return Scaffold(
//       appBar: CustomAppBarSecondary(
//         height: getHorizontalSize(60),
//         leading: IconButton(
//             icon: Icon(Icons.chevron_left, color: Colors.black,),
//           onPressed: () {
//               Get.back();
//           },
//         ),
//       ),
//       body: SizedBox(
//         height: MediaQuery.of(context).size.height,
//         width: double.infinity,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(timeDisplay),
//               const Text('Calling...'),
//               TextButton(
//                 style: ButtonStyle(
//                   foregroundColor:
//                   MaterialStateProperty.all<Color>(Colors.blue),
//                 ),
//                 onPressed: () async {
//                   if (calling != null) {
//                     await makeFakeConnectedCall(calling!.id!);
//                     startTimer();
//                   }
//                 },
//                 child: const Text('Fake Connected Call'),
//               ),
//               ElevatedButton(
//                 style: ButtonStyle(
//                   foregroundColor:
//                   MaterialStateProperty.all<Color>(Colors.blue),
//                 ),
//                 onPressed: () async {
//                   if (calling != null) {
//                     await makeEndCall(calling!.id!);
//                     calling = null;
//                   }
//
//                   await requestHttp('END_CALL');
//                 },
//                 child: const Text('End Call'),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Future<void> makeFakeConnectedCall(id) async {
//     await FlutterCallkitIncoming.setCallConnected(id);
//   }
//
//   Future<void> makeEndCall(id) async {
//     await FlutterCallkitIncoming.endCall(id);
//   }
//
//   //check with https://webhook.site/#!/2748bc41-8599-4093-b8ad-93fd328f1cd2
//   Future<void> requestHttp(content) async {
//     get(Uri.parse(
//         'https://webhook.site/2748bc41-8599-4093-b8ad-93fd328f1cd2?data=$content'));
//   }
//
//   @override
//   void dispose() {
//     super.dispose();
//     _timer?.cancel();
//     if (calling != null) FlutterCallkitIncoming.endCall(calling!.id!);
//   }
// }

const APP_ID = "20971648246c496fa6e2a8856c4e0d1e";
class NoCoordinator extends StatefulWidget {
  const NoCoordinator({super.key, this.phoneNumber});
  final String? phoneNumber;
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

  @override
  void initState() {
    callToken = idGenerator();
    provider = Get.put(QueryProvider());
    initiateCall();
    super.initState();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void initiateCall() async {
    // Loaders.loadingDialog(title: "Calling Support");
    try{
      callState = "Finding Available HCF";
      bool res = await provider.placeCall(callToken, userId: widget.phoneNumber);
      if(!res){
        Loaders.errorDialog("Call Could not be placed");
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
          onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
            debugPrint("remote user $remoteUid left channel");
            setState(() {
              callState = "Reconnecting";
            });
            _startCallTimer();
          },
          onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
            debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
          },
          onError: (ErrorCodeType codeType, message){
            debugPrint("$codeType : $message");
            _startCallTimer();
          }
      ),
    );
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine!.enableAudio();
    await _engine!.setDefaultAudioRouteToSpeakerphone(false);
    await joinChannel();
  }

  Future<void> joinChannel() async {
    await _engine!.joinChannel(channelId: callToken, token: APP_ID, uid: 0, options: const ChannelMediaOptions() );
    // _startCallTimer();
  }

  Future<void> leaveChannel() async {
    await _engine!.leaveChannel();
    // _startCallTimer();
    setState(() {
      callState = "Disconnected";
    });
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
        _callDuration = _callDuration + oneSecond;
        if(callState == "Connected"){
          _startCallTimer();
        }
      });
    });
  }

  void _toggleSpeaker() async{
    await _engine!.setEnableSpeakerphone(_isSpeakerOn);
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _toggleMute() async{
    await _engine!.muteLocalAudioStream(_isMuted);
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _hangUp() async{
    // initiateCall();
    await leaveChannel();
    setState(() {
      _isCallActive = false;
    });
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
                    icon: Icon(_isSpeakerOn ? Icons.volume_up : Icons.volume_off),
                    onPressed: _toggleSpeaker,
                  ),
                  const SizedBox(width: 20),
                  IconButton(
                    icon: Icon(_isMuted ? Icons.mic_off : Icons.mic),
                    onPressed: _toggleMute,
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    icon: Icon(Icons.call_end),
                    onPressed: _hangUp,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}