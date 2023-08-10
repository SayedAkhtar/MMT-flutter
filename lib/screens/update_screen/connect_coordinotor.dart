import 'dart:convert';
import 'dart:async';

import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';

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

class NoCoordinator extends StatefulWidget {
  const NoCoordinator({super.key});
  @override
  _NoCoordinatorState createState() => _NoCoordinatorState();
}

class _NoCoordinatorState extends State<NoCoordinator> {
  bool _isSpeakerOn = false;
  bool _isMuted = false;
  bool _isCallActive = false;
  Duration _callDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _startCallTimer();
  }

  void _startCallTimer() {
    const oneSecond = Duration(seconds: 1);
    Future.delayed(oneSecond, () {
      setState(() {
        _callDuration = _callDuration + oneSecond;
        _startCallTimer();
      });
    });
  }

  void _toggleSpeaker() {
    setState(() {
      _isSpeakerOn = !_isSpeakerOn;
    });
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  void _hangUp() {
    setState(() {
      _isCallActive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSecondary(
        height: getHorizontalSize(50),
        leading:  IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black, size: 36,),
          onPressed: () {
              Get.back();
          },
        ),
      ),
      body: Center(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/avatar.png'), // Replace with your image
                radius: 60,
              ),
              SizedBox(height: 20),
              Text(
                'User Name',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Call duration: ${_callDuration.inMinutes}:${_callDuration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_isSpeakerOn ? Icons.volume_up : Icons.volume_off),
                    onPressed: _toggleSpeaker,
                  ),
                  SizedBox(width: 20),
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