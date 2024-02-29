// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/screens/connects/chat_page.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_uikit/agora_uikit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/message_model.dart';
import 'package:logger/logger.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

class Video_Call_Screen extends StatefulWidget {
  const Video_Call_Screen({super.key});

  @override
  State<Video_Call_Screen> createState() => _Video_Call_ScreenState();
}

class _Video_Call_ScreenState extends State<Video_Call_Screen> {
  dynamic argumentData = Get.arguments;
  late AgoraClient client;

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
    initAgora();
    database = FirebaseDatabase.instance;
    dbRef = FirebaseDatabase.instance
        .ref("messages/${argumentData['channelName']}/");
    newMessageCount = 0;
    // getMessages();
    subscribe();
    WakelockPlus.enable();
    super.initState();
  }

  @override
  void dispose() {
    disposeAgora();
    super.dispose();
    // database.goOffline();
  }

  Future<void> initAgora() async {
    client = AgoraClient(
      agoraConnectionData: AgoraConnectionData(
        appId: argumentData['token'],
        channelName: argumentData['channelName'],
        username: "Patient",
        uid: 1
      ),
    );
    await client.initialize();
    client.engine.setLogLevel(LogLevel.logLevelNone);
    // client.engine.registerEventHandler(RtcEngineEventHandler(
    //   onLeaveChannel: (connection, stats){
    //     Get.offAndToNamed(Routes.home);
    //   }
    // ));
  }

  Future<void> disposeAgora() async {
    if (client.isInitialized) {
      await client.release();
    }
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
  void subscribe() async{
    Stream<DatabaseEvent> stream = dbRef.onValue;
    stream.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        Map messageJson = event.snapshot.value as Map;
        messageJson.forEach((key, value) {
          messages.add(ChatMessage.fromMap(value));
        });
        setState(() {
          newMessageCount++;
        });
      }// DataSnapshot
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [

            AgoraVideoViewer(
              client: client,
              layoutType: Layout.grid,
              enableHostControls: true,
              showAVState: true,// Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: client,
              addScreenSharing: false, // Add this to enable screen sharing
              // enabledButtons: [],
              extraButtons: [
              ],
            ),
            Align(
              alignment: Alignment(0.95, -0.95),
              child: Stack(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        newMessageCount = 0;
                      });
                      Get.to(() => ChatPage(
                        previousMessage: messages,
                        channelName: argumentData['channelName'],
                      ));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MYcolors.whitecolor,
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
                            borderRadius: BorderRadius.circular(100)),
                        child: Center(
                            child: Text(
                              newMessageCount.toString(),
                              style: AppStyle.txtSourceSansProSemiBold14
                                  .copyWith(color: Colors.white),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment(-0.95, -0.95),
              child: ElevatedButton(
                onPressed: () {
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(14),
                ),
                child: Icon(Icons.chevron_left),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
