// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/controller/controllers/teleconsult_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/connects/chat_page.dart';
import 'package:intl/intl.dart';

import '../../constants/colors.dart';

class Connect_Home_page extends StatefulWidget {
  const Connect_Home_page({super.key});

  @override
  State<Connect_Home_page> createState() => _Connect_Home_pageState();
}

class _Connect_Home_pageState extends State<Connect_Home_page> {
  int currentindex = 0;
  late TeleconsultController _controller;
  @override
  void initState() {
    // TODO: implement initState
    _controller = Get.put(TeleconsultController());
    _controller.getAllConsultations();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        pageName: "Teleconsultation History",
        showDivider: true,
        showBack: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: MYcolors.greycolor,
                borderRadius: BorderRadius.circular(10),
              ),
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentindex = 0;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: currentindex == 0
                            ? MYcolors.whitecolor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Text(
                        "Calls".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // fontFamily: "Brandon",
                            fontSize: 15,
                            color: MYcolors.blacklightcolors),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentindex = 1;
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: currentindex == 1
                            ? MYcolors.whitecolor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      height: MediaQuery.of(context).size.height * 0.04,
                      width: MediaQuery.of(context).size.width * 0.38,
                      child: Text(
                        "Messages".tr,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // fontFamily: "Brandon",
                            fontSize: 15,
                            color: MYcolors.blacklightcolors),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: CustomSpacer.M,
            ),

            Expanded(
              child: IndexedStack(
                index: currentindex,
                children: [
                  SizedBox(
                    child: GetBuilder<TeleconsultController>(builder: (ctrl) {
                      if(!_controller.consultationsLoaded){
                        return Center(child: CircularProgressIndicator());
                      }
                      if(_controller.consultationList.isEmpty && _controller.consultationsLoaded){
                        return Text("No Consultation to show");
                      }
                      return ListView.builder(
                          itemCount: _controller.consultationList.length,
                          itemBuilder: (ctx, idx) {
                            var _schedule = _controller.consultationList[idx]
                                ['scheduled_at'];
                            var _time = DateFormat('yyyy-MM-dd \nhh:mm a')
                                .format(DateTime.parse(_controller
                                    .consultationList[idx]['updated_at']));
                            return GestureDetector(
                              onTap: () {
                                if (!_controller.consultationList[idx]
                                    ['is_active']) {
                                  Get.showSnackbar(GetSnackBar(
                                    title: "Consultation not yet active",
                                    message: "Scheduled at :" + _schedule,
                                  ));
                                } else {
                                  Get.toNamed(
                                    Routes.videoChat,
                                    arguments: {
                                      "channelName":
                                          _controller.consultationList[idx]
                                              ['channel_name'],
                                      "token": _controller.consultationList[idx]
                                          ['agora_id']
                                    },
                                  );
                                }
                              },
                              child: SizedBox(
                                child: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      ),
                                      height: 80,
                                      width: 80,
                                      child: Image.asset(
                                        "Images/PR.png",
                                        // fit: BoxFit.fill,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Doctor",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                // fontFamily: "Brandon",
                                                fontSize: 15,
                                                color:
                                                    MYcolors.blacklightcolors),
                                          ),
                                          Text(
                                            _controller.consultationList[idx]
                                                    ['is_active']
                                                ? "Active Consultation Call".tr
                                                : "Waiting for call to become active",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15,
                                                color: _controller
                                                            .consultationList[
                                                        idx]['is_active']
                                                    ? MYcolors.greencolor
                                                    : MYcolors.redcolor),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Text(
                                      _time,
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.end,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }),
                  ),
                  SizedBox(
                    child: ListView.builder(
                        itemCount: 1,
                        itemBuilder: (ctx, idx) {
                          return GestureDetector(
                            onTap: () {
                              Get.to(Chat_page());
                            },
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.02,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      // color: MYcolors.bluecolor,
                                      borderRadius: BorderRadius.circular(100),
                                    ),
                                    height: MediaQuery.of(context).size.height *
                                        0.07,
                                    width: MediaQuery.of(context).size.width *
                                        0.15,
                                    child: Image.asset(
                                      "Images/PR.png",
                                      // fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text(
                                        "Madhu",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            // fontFamily: "Brandon",
                                            fontSize: 15,
                                            color: MYcolors.blacklightcolors),
                                      ),
                                      Text(
                                        "Hi! can you please send me some....",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          // fontFamily: "Brandon",
                                          fontSize: 12,
                                          // color: MYcolors.greencolor
                                        ),
                                      )
                                    ],
                                  ),
                                  // SizedBox(
                                  //   width: MediaQuery.of(context).size.width * 0.05,
                                  // ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("05:02 PM"),
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.005,
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
