// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:MyMedTrip/models/consultation.dart';
import 'package:MyMedTrip/providers/teleconsult_provider.dart';
import 'package:MyMedTrip/screens/connects/AgoraVideoChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/teleconsult_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';
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
        pageName: "Teleconsultation History".tr,
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
                child: FutureBuilder<List<Consultation>>(
                  future: Get.put(TeleconsultProvider()).getConsultationList(),
                  builder: (ctx, AsyncSnapshot<List<Consultation>> snapshot){
                    // return Text(snapshot.data.toString());
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.data!.isEmpty) {
                      return Text("No Consultation to show".tr);
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (ctx, idx) {
                          Consultation curr = snapshot.data![idx];
                          var schedule = curr.scheduledAt;
                          var time = DateFormat('yyyy-MM-dd \nhh:mm a')
                              .format(DateTime.parse(curr.updatedAt));
                          return GestureDetector(
                            onTap: () {
                              if (!curr.isActive) {
                                Get.showSnackbar(GetSnackBar(
                                  title: "Consultation not yet active".tr,
                                  message: "Scheduled at :".tr +schedule,
                                  duration: Duration(seconds: 5),
                                  showProgressIndicator: true,
                                  onTap: (event){
                                    Get.back();
                                  },
                                ));
                              } else {
                                // Get.to(AgoraVideoChatScreen(
                                //     channelName: _controller.consultationList[idx]['channel_name'],
                                //     appId: _controller.consultationList[idx]['agora_id']
                                // ));


                                Get.toNamed(
                                  Routes.videoChat,
                                  arguments: {
                                    "channelName":
                                    curr.channelName,
                                    "token": curr.agoraId
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
                                          "TELE-${curr.id}",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              // fontFamily: "Brandon",
                                              fontSize: 15,
                                              color:
                                              MYcolors.blacklightcolors),
                                        ),
                                        Text(
                                          curr.doctorName ?? 'Doctor',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              // fontFamily: "Brandon",
                                              fontSize: 15,
                                              color:
                                              MYcolors.blacklightcolors),
                                        ),
                                        Text(
                                              curr.isActive
                                              ? "Active Consultation Call".tr
                                              : "Waiting for call to become active".tr,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: curr.isActive ? MYcolors.greencolor
                                                  : MYcolors.redcolor),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    time,
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
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
