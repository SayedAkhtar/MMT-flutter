// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/models/message_model.dart';
import 'package:MyMedTrip/models/user_model.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/colors.dart';

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
  final ChannelProfileType _channelProfileType = ChannelProfileType.channelProfileLiveBroadcasting;

  late FirebaseDatabase database;
  late DatabaseReference dbRef;
  late final storageRef;
  final ScrollController _messageScrollController = ScrollController();

  int messageFrom = 1;
  String messageType = "image";
  String filePath = "";
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    requestPermissions();
    initAgora();
    _joinChannel();
    database = FirebaseDatabase.instance;
    dbRef = FirebaseDatabase.instance
        .ref("messages/${argumentData['channelName']}/");
    storageRef = FirebaseStorage.instance.ref('gs://mymedtrip-app.appspot.com/')
    .child('message_doc')
    .child(argumentData['channelName']);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeAgora();
    messageController.dispose();
    database.goOffline();
  }

  void requestPermissions() async {
    await [Permission.microphone, Permission.camera].request();
  }

  Future<void> initAgora() async {
    _engine = createAgoraRtcEngine();

    await _engine.initialize(RtcEngineContext(
      appId: argumentData['token'],
    ));
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
    if (enableAudio) {
      await _engine.disableAudio();
    } else {
      await _engine.enableAudio();
    }
    setState(() {
      enableAudio = !enableAudio;
    });
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
              alignment: Alignment(-0.95, -1),
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
              alignment: Alignment.topRight,
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _toggleAudio,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          enableAudio ? Colors.black26 : Colors.greenAccent,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(14),
                    ),
                    child: Icon(Icons.mic_off),
                  ),
                  CustomSpacer.s(),
                  ElevatedButton(
                    onPressed: () async{
                      if(!_localUserJoined){
                        await _joinChannel();
                      }else{
                        await _engine.leaveChannel(
                          options: LeaveChannelOptions(
                            stopAllEffect: true,
                            stopAudioMixing: true,
                            stopMicrophoneRecording: true
                          )
                        );
                      }
                      // _localUserJoined ? disposeAgora() : _joinChannel();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _localUserJoined? Colors.redAccent: Colors.green,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(14),
                    ),
                    child: _localUserJoined? Icon(Icons.phone_disabled):Icon(Icons.phone_enabled),
                  ),
                  CustomSpacer.s(),
                  ElevatedButton(
                    onPressed: () {
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
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          isDismissible: true,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30.0),
                                topRight: Radius.circular(30.0)),
                          ),
                          builder: (BuildContext context) {
                            return chatContainer();
                          });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black26,
                      shape: CircleBorder(),
                      padding: EdgeInsets.all(14),
                    ),
                    child: Icon(Icons.messenger_outline_outlined),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  // Display remote user's video
  Widget _remoteVideo() {
    if (_remoteUid.isNotEmpty) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid.first),
          connection: RtcConnection(channelId: argumentData['channelName']),
        ),
      );
    } else {
      return Text(
        _localUserJoined?'Please wait for remote user to join':" Click on the call button to connect call",
        style: TextStyle(fontSize: 16.0),
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _sentMessage(Message data) {
    Widget child;
    switch (data.type) {
      case Message.IMAGE:
        child = InkWell(
            onTap: () {
              String ext = data.message.split('.').last != ''? data.message.split('.').last:'jpg';
              Utils.saveFileToDevice(
                  "mmt_${DateTime.now().microsecond}.$ext", data.message);
            },
            child: Image.network(data.message));
        break;
      case Message.FILE:
        child = InkWell(
            onTap: () {
              String ext = data.message.split('.').last;
              Utils.saveFileToDevice(
                  "mmt_${DateTime.now().microsecond}.$ext", data.message);
            },
            child: Icon(
              Icons.file_copy_rounded,
              size: 32,
            ));
        break;
      default:
        child = Text(
          data.message,
          style: TextStyle(
            fontSize: 15,
          ),
        );
    }
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(8.0),
          margin: EdgeInsets.only(bottom: 16.0),
          decoration: BoxDecoration(
            color: MYcolors.greycolor,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
          ),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.65,
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _recievedMessage(Message data) {
    Widget child;
    switch (data.type) {
      case Message.IMAGE:
        child = Image.network(data.message);
        break;
      case Message.FILE:
        child = Icon(
          Icons.file_copy_rounded,
          size: 32,
        );
        break;
      default:
        child = Text(
          data.message,
          style: TextStyle(
            fontSize: 15,
          ),
        );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(bottom: 16.0),
            decoration: BoxDecoration(
              color: MYcolors.greenlightcolor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(0),
                  bottomLeft: Radius.circular(10),
                  bottomRight: Radius.circular(10)),
            ),
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.65,
            ),
            child: child),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.04,
        ),
      ],
    );
  }

  Widget chatContainer() {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(CustomSpacer.S),
                  child: StreamBuilder<DatabaseEvent>(
                      stream: dbRef.onValue,
                      builder: (context, AsyncSnapshot<DatabaseEvent> event) {
                        if (event.hasData &&
                            event.connectionState == ConnectionState.active) {
                          return ListView.builder(
                              shrinkWrap: true,
                              controller: _messageScrollController,
                              itemCount: event.data?.snapshot.children.length,
                              itemBuilder: (ctx, idx) {
                                List<DataSnapshot> obj =
                                    event.data!.snapshot.children.toList();
                                Message msg = Message.fromMap(
                                    obj[idx].value as Map<dynamic, dynamic>);
                                if (msg.from == LocalUser.TYPE_PATIENT) {
                                  return _sentMessage(msg);
                                } else {
                                  return _recievedMessage(msg);
                                }
                              });
                        }
                        if (ConnectionState.waiting == event.connectionState) {
                          return Text("Loading messages");
                        }
                        return Text("No Messages yet");
                      }),
                ),
              ),
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.black12, width: 1.5),
                              borderRadius: BorderRadius.circular(100)),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  enabled: messageType != Message.TEXT,
                                  controller: messageController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.fromLTRB(
                                        20.0, 5.0, 20.0, 5.0),
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                              IconButton(
                                  onPressed: () async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                      dialogTitle: "Upload documents",
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'jpeg',
                                        'jpg',
                                        'heic',
                                        'png'
                                      ],
                                    );

                                    if (result != null) {
                                      File file = File(result.files.single.path!);
                                      String ext = result.files.single.path!.split('.').last;
                                      try {
                                        Loaders.loadingDialog();
                                        final finalRef = storageRef.child("${DateTime.now().millisecondsSinceEpoch.toString()}");
                                        await finalRef.putFile(file);
                                        filePath = await finalRef.getDownloadURL();
                                        await dbRef.push().set({
                                          "from": LocalUser.TYPE_PATIENT,
                                          "type": messageType,
                                          "message": filePath,
                                        });
                                        Get.back();
                                        _messageScrollController.animateTo(
                                            _messageScrollController.position.maxScrollExtent,
                                            duration: const Duration(milliseconds: 500),
                                            curve: Curves.ease);
                                      } on FirebaseException catch (e) {
                                        print(e.toString());
                                      }

                                    } else {
                                      // User canceled the picker
                                    }
                                  },
                                  icon: Icon(Icons.image_outlined))
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          var t = await dbRef.get();
                          print(t);
                          await dbRef.push().set({
                            "from": LocalUser.TYPE_PATIENT,
                            "type": Message.TEXT,
                            "message": messageController.text,
                          });

                          _messageScrollController.animateTo(
                              _messageScrollController.position.maxScrollExtent,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(14),
                        ),
                        child: Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
