// ignore_for_file: prefer_const_constructors

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/colors.dart';

class Video_Call_Screen extends StatefulWidget {
  const Video_Call_Screen({super.key});

  @override
  State<Video_Call_Screen> createState() => _Video_Call_ScreenState();
}

class _Video_Call_ScreenState extends State<Video_Call_Screen> {
  Set<int> _remoteUid = {};
  bool _localUserJoined = false, switchCamera = true, switchRender = true;
  late RtcEngine _engine;
  ChannelProfileType _channelProfileType = ChannelProfileType.channelProfileLiveBroadcasting;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
    initAgora();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeAgora();
  }

  void requestPermissions() async{
    await [Permission.microphone, Permission.camera].request();
  }

  Future<void> initAgora() async {

    _engine = createAgoraRtcEngine();

    await _engine.initialize(const RtcEngineContext(
      appId: "20971648246c496fa6e2a8856c4e0d1e",
    ));
    await _engine.setLogLevel(LogLevel.logLevelNone);
    print("+++++++++++++++ Engine Initialized");

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (ErrorCodeType err, String msg) {
          print("[onError] err: $err, msg: $msg");
        },
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid.add(remoteUid);
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid.removeWhere((element) => element == remoteUid);
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
          setState(() {
            _localUserJoined = false;
            _remoteUid.clear();
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        dimensions: VideoDimensions(
          width: 640,
          height: 360
        ),
        frameRate: 15,
        bitrate: 0,
      )
    );

  }

  Future<void> _joinChannel() async {
    await _engine.joinChannel(
      token: "",
      channelId: "my-channel",
      uid: 0,
      options: ChannelMediaOptions(
        channelProfile: _channelProfileType,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> disposeAgora() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> _switchCamera() async {
    await _engine.switchCamera();
    setState(() {
      switchCamera = !switchCamera;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 150,
              height: 200,
              child: Center(
                child: _localUserJoined ? AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: _engine,
                    canvas: const VideoCanvas(uid: 0),
                    useFlutterTexture: false,
                    useAndroidSurfaceView: true,
                  ),
                ): CircularProgressIndicator(),
              )
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(onPressed: (){
              _localUserJoined? disposeAgora() : _joinChannel();
            }, child: Text(!_localUserJoined? "Join Call": "End Call")),
          )
        ],
      ),
    ));
  }
  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid.isNotEmpty) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid.first),
          connection: const RtcConnection(channelId: "my-channel"),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}
