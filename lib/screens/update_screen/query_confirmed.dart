// ignore_for_file: prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/constants/query_step_name.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/models/confirmed_query.dart';
import 'package:MyMedTrip/providers/query_provider.dart';
import 'package:MyMedTrip/screens/update_screen/connect_coordinotor.dart';

import '../connects/voice_call.dart';

class QueryConfirmed extends GetView<QueryController> {
  const QueryConfirmed({super.key});
  @override
  Widget build(BuildContext context) {
    QueryProvider _provider = Get.put(QueryProvider());
    return Scaffold(
      appBar: CustomAppBar(pageName: "Confirmed details".tr, showDivider: true ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder(
                future: _provider.getConfirmedQueryDetail(controller.selectedQuery),
                builder: (context, AsyncSnapshot data) {
                  if (data.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hotel Details".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${data.data?.accommodation?.name} \n${data.data?.accommodation?.address}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                        CustomSpacer.m(),
                        Text(
                          "Cab Details".tr,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          data.data?.cab?.name == null?"Not Assigned":"${data.data?.cab?.name}\n${data.data?.cab?.type} \n${data.data?.cab?.number}",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 15,
                          ),
                        ),
                        CustomSpacer.m(),
                        Text(
                          "Coordinator details",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.15,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 0.4,
                          child: Image.network(data.data!.coordinator!.image!),
                        ),
                        Text(
                          "Name : ${data.data?.coordinator?.name}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "${'Phone Number'.tr} : ${data.data?.coordinator?.phone}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () {
                            Get.to(NoCoordinator());
                          },
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color?>(
                                  MYcolors.bluecolor
                              )
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            width: double.infinity,
                            child: Text(
                              "Connect to Coordinator".tr,
                              style: TextStyle(
                                color: MYcolors.whitecolor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        CustomSpacer.xs(),
                      ],
                    );
                  }
                  else if(data.connectionState == ConnectionState.done && !data.hasData){
                    return NoCoordinator();
                  }
                  else {
                    return Center(child: CircularProgressIndicator());
                  }
                }
              ),
            ),
            kDebugMode?
            ElevatedButton(
              onPressed: () {
                Get.to(NoCoordinator());
              },
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color?>(
                      MYcolors.blueGray400
                  )
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                width: double.infinity,
                child: Text(
                  "Contact Support".tr,
                  style: TextStyle(
                    color: MYcolors.whitecolor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ):SizedBox()
          ],
        ),
      ),
    );
  }
}
