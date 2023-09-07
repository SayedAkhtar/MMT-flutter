// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:MyMedTrip/screens/connects/chat_page.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/message_model.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class Video_Call_Screen extends StatefulWidget {
  const Video_Call_Screen({super.key});

  @override
  State<Video_Call_Screen> createState() => _Video_Call_ScreenState();
}

class _Video_Call_ScreenState extends State<Video_Call_Screen> {
  dynamic argumentData = Get.arguments;
  Set<int> _remoteUid = {};
  bool _localUserJoined = false,
      switchCamera = true,
      switchRender = true,
      enableAudio = true;
  late RtcEngine _engine;
  final ChannelProfileType _channelProfileType =
      ChannelProfileType.channelProfileLiveBroadcasting;

  late FirebaseDatabase database;
  late DatabaseReference dbRef;
  late String storageRef;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  List<ChatMessage> messages = [];
  int newMessageCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    requestPermissions();
    initAgora();
    _joinChannel();
    database = FirebaseDatabase.instance;
    dbRef = FirebaseDatabase.instance
        .ref("messages/${argumentData['channelName']}/");
    newMessageCount = 0;
    getMessages();
    WakelockPlus.enable();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

      const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
      const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

      const InitializationSettings initializationSettings =
      InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin);
      await flutterLocalNotificationsPlugin.initialize(initializationSettings,
          onDidReceiveNotificationResponse: (payload) {});

      if(message.data.isNotEmpty && message.data['page_action'] == 'active_chat'){
        setState(() {
          newMessageCount = newMessageCount+1;
        });
        return;
      }
    });
    super.initState();
  }




  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeAgora();
    // database.goOffline();
  }

  void requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  Future<void> initAgora() async {
    _engine = createAgoraRtcEngine();

    await _engine.initialize(RtcEngineContext(
        appId: argumentData['token'],
        logConfig: LogConfig(level: LogLevel.logLevelNone)));
    await _engine.setLogLevel(LogLevel.logLevelNone);

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
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
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
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.setVideoEncoderConfiguration(const VideoEncoderConfiguration(
      dimensions: VideoDimensions(width: 640, height: 360),
      frameRate: 15,
      bitrate: 0,
    ));
    await _engine.startPreview();
  }

  Future<void> _joinChannel() async {
    print(argumentData);
    await _engine.joinChannel(
      token: argumentData['token'],
      channelId: argumentData['channelName'],
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

  Future<void> _toggleAudio() async {
    await _engine.muteLocalAudioStream(enableAudio);
    setState(() {
      enableAudio = !enableAudio;
    });
  }

  void getMessages() async {
    List<ChatMessage> temp = [];

    try {
      DatabaseEvent event = await dbRef.once();

      if (event.snapshot.exists) {
        Map messageJson = event.snapshot.value as Map;
        messageJson.forEach((key, value) {
          temp.add(ChatMessage.fromMap(value));
        });
        setState(() {
          messages = temp;
        });
      } else {
        Logger().d("No data Available");
      }
    } catch (e, stacktrace) {
      Loaders.errorDialog("${e.toString()} $stacktrace",
          stackTrace: stacktrace);
      print('Error fetching data: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: _remoteVideo(),
            ),
            Align(
              alignment: Alignment(-0.95, -0.95),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black12,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(14),
                ),
                child: Icon(Icons.chevron_left),
              ),
            ),
            Align(
              alignment: Alignment(0.95, -0.90),
              child: Container(
                  width: 150,
                  height: 180,
                  decoration: BoxDecoration(
                      color: Colors.deepOrange,
                      image: DecorationImage(
                          image: AssetImage('Images/avatar-placeholder.jpeg'),
                          fit: BoxFit.fill),
                      borderRadius: BorderRadius.circular(10)),
                  clipBehavior: Clip.hardEdge,
                  child: Center(
                    child: _localUserJoined
                        ? AgoraVideoView(
                            controller: VideoViewController(
                              rtcEngine: _engine,
                              canvas: const VideoCanvas(uid: 0),
                              useFlutterTexture: false,
                              useAndroidSurfaceView: true,
                            ),
                          )
                        : CircularProgressIndicator(),
                  )),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(bottom: CustomSpacer.L),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _toggleAudio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            enableAudio ? Colors.black26 : Colors.redAccent,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Icon(Icons.mic_off),
                    ),
                    CustomSpacer.s(),
                    ElevatedButton(
                      onPressed: () async {
                        if (!_localUserJoined) {
                          await _joinChannel();
                        } else {
                          await _engine.leaveChannel(
                              options: LeaveChannelOptions(
                                  stopAllEffect: true,
                                  stopAudioMixing: true,
                                  stopMicrophoneRecording: true));
                        }
                        // _localUserJoined ? disposeAgora() : _joinChannel();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _localUserJoined ? Colors.redAccent : Colors.green,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(14),
                      ),
                      child: _localUserJoined
                          ? Icon(Icons.phone_disabled)
                          : Icon(Icons.phone_enabled),
                    ),
                    CustomSpacer.s(),
                    ElevatedButton(
                      onPressed: () {
                        // getMessages();
                        _switchCamera();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black26,
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(14),
                      ),
                      child: Icon(Icons.cameraswitch_rounded),
                    ),
                    CustomSpacer.s(),

                    Stack(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              newMessageCount = 0;
                            });
                            Get.to(() => ChatPage(previousMessage: messages, channelName: argumentData['channelName'],));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MYcolors.bluecolor,
                            shape: CircleBorder(),
                            padding: EdgeInsets.all(14),
                          ),
                          child: const Icon(Icons.messenger_outline_outlined),
                        ),
                        Visibility(
                          visible: newMessageCount.isGreaterThan(0),
                          child: Positioned(
                            right: 0,
                            child: Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                  color: Colors.redAccent,
                                  borderRadius: BorderRadius.circular(100)
                              ),
                              child: Center(child: Text(newMessageCount.toString(), style: AppStyle.txtSourceSansProSemiBold14.copyWith(color: Colors.white),)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  // Display remote user's video
  Widget _remoteVideo() {
    List<AgoraVideoView> _child = [];
    if (_remoteUid.isNotEmpty) {
      for (var element in _remoteUid) {
        _child.add(AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: element),
            connection: RtcConnection(channelId: argumentData['channelName']),
          ),
        ));
      }
      return GridView.count(
        scrollDirection: Axis.horizontal,
        crossAxisCount: _remoteUid.length,
        shrinkWrap: true,
        children: _child,
      );
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid.first),
          connection: RtcConnection(channelId: argumentData['channelName']),
        ),
      );
    } else {
      return Text(
        _localUserJoined
            ? 'Please wait for remote user to join'
            : " Click on the call button to connect call",
        style: TextStyle(fontSize: 16.0),
        textAlign: TextAlign.center,
      );
    }
  }
}
