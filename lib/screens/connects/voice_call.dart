import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/CustomImageView.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../constants/colors.dart';

const APP_ID = "20971648246c496fa6e2a8856c4e0d1e";
class CoordinatorCallPage extends StatefulWidget {
  const CoordinatorCallPage({super.key});

  @override
  State<CoordinatorCallPage> createState() => _CoordinatorCallPageState();
}

class _CoordinatorCallPageState extends State<CoordinatorCallPage> with SingleTickerProviderStateMixin {
  String callState = "";
  CallState state = CallState.connecting;
  late RtcEngine _engine;
  late Duration elapsed;
  late final Ticker _ticker;
  @override
  void initState() {
    // TODO: implement initState
    callState = "Calling....".tr;
    elapsed = Duration.zero;
    super.initState();
    initializeAgora();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeAgora();
    _ticker.dispose();
  }

  Future<void> initializeAgora() async {
    await [Permission.microphone].request();
    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: APP_ID,
    ));
    await _engine.setLogLevel(LogLevel.logLevelNone);
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            callState = "Connecting...".tr;
            state = CallState.connecting;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          startCountTimer();
          setState(() {
            callState = "Connected".tr;
            state = CallState.connected;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid, UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            // callState = "Reconnecting";
            state = CallState.reconnecting;
          });

        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint('[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
        onError: (ErrorCodeType codeType, message){
          debugPrint("$codeType : $message");
        }
      ),
    );
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableAudio();
  }

  Future<void> joinChannel() async {
    await _engine.joinChannel(channelId: 'doctor_channel', token: APP_ID, uid: 0, options: const ChannelMediaOptions() );
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
    setState(() {
      state = CallState.disconnected;
    });
  }

  Future<void> disposeAgora() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  void startCountTimer(){
    _ticker = createTicker((elapsed) {
      print(elapsed);
      setState(() {
        elapsed = elapsed;
      });
    });
    _ticker.start();
  }

  String formatedTime({required int timeInSecond}) {
    int sec = timeInSecond % 60;
    int min = (timeInSecond / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageName: "", showDivider: false,),
      body: Column(
    children: [
      CustomImageView(
        imagePath: "Images/rrr.png",
        height: getHorizontalSize(150),
      ),
      Text(
        "Coordinator name".tr,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      CustomSpacer.s(),
      Text(
        callState,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      CustomSpacer.s(),
      elapsed.inSeconds != 0?
      Text(
        formatedTime(timeInSecond: elapsed.inSeconds),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ):const SizedBox(),
      const Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          InkWell(
            onTap: (){
              joinChannel();
            },
            onDoubleTap: (){
              leaveChannel();
            },
            child: Container(
                padding: const EdgeInsets.all(3),
                height: MediaQuery.of(context).size.height * 0.09,
                width: MediaQuery.of(context).size.width * 0.15,
                decoration: const BoxDecoration(
                    color: MYcolors.redcolor, shape: BoxShape.circle
                    ),
                child: const Icon(
                  Icons.call_end,
                  color: MYcolors.whitecolor,
                )),
          ),
        ],
      ),
      CustomSpacer.l(),
    ],
      ),
    );
  }
}
enum CallState{
  connected,
  disconnected,
  connecting,
  reconnecting
}
