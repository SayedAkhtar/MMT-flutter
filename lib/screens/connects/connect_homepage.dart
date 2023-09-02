// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/teleconsult_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/connects/chat_page.dart';
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
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    bool isRegistered = Get.isRegistered<TeleconsultController>();
    _controller = Get.put(TeleconsultController());
    _controller.getAllConsultations();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Teleconsultation History",
        showDivider: true,
        showBack: false,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          _controller.getAllConsultations();
          setState(() {
            isLoading = false;
          });
        },
        child: isLoading?Center(child: CircularProgressIndicator(),):
        Padding(
          padding: const EdgeInsets.all(CustomSpacer.S),
          child: Column(
            children: [
              Expanded(
                child: IndexedStack(
                  index: currentindex,
                  children: [
                    SizedBox(
                      child: GetBuilder<TeleconsultController>(builder: (ctrl) {
                        if (!_controller.consultationsLoaded) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (_controller.consultationList.isEmpty &&
                            _controller.consultationsLoaded) {
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
                                      message: "Scheduled at :$_schedule",
                                      duration: Duration(seconds: 5),
                                      showProgressIndicator: true,
                                      onTap: (event){
                                        Get.back();
                                      },
                                    ));
                                  } else {
                                    print(_controller.consultationList[idx]);
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
                                              "TELE-${_controller.consultationList[idx]['id']}",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  // fontFamily: "Brandon",
                                                  fontSize: 15,
                                                  color:
                                                  MYcolors.blacklightcolors),
                                            ),
                                            Text(
                                              "${_controller.consultationList[idx]
                                              ['doctor_name'] ?? 'Doctor'}",
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
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
