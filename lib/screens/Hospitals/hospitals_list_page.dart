// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/constants/api_constants.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/providers/hospital_provider.dart';
import 'package:mmt_/screens/Hospitals/hospital_preview.dart';
import 'package:mmt_/constants/colors.dart';

import '../../controller/controllers/hospital_controller.dart';
import '../../models/hospital_model.dart';

class HospitalsListPage extends GetView<HospitalController> {
  const HospitalsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    HospitalProvider provider = Get.put(HospitalProvider());
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "All Hospitals",
        showDivider: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(CustomSpacer.S),
        child: FutureBuilder(
          future: provider.getAllHospitals(),
          builder: (_, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator(),);
            }else if(snapshot.connectionState == ConnectionState.done){
              if(snapshot.hasData && snapshot.data != null &&snapshot.data!.isNotEmpty){
                List<Hospital?>? hospitals = snapshot.data;
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (_, i) {
                    return GestureDetector(
                      onTap: () {
                        controller.openHospitalDetails(
                            hospitals[i]!.id!);
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * 0.12,
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: hospitals?[i]?.logo != null?
                                    NetworkImage(hospitals![i]!.logo!): NetworkImage(NO_IMAGE),
                                  ),
                                  color: MYcolors.whitecolor,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      // color: Color.fromARGB(255, 189, 181, 181),
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 2,
                                      spreadRadius: 0,
                                      offset: Offset(0, 1),
                                    )
                                  ]),
                            ),
                            Flexible(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${hospitals![i]!.name}",
                                    style: TextStyle(
                                      // fontWeight: FontWeight.bold,
                                        color: MYcolors.blacklightcolors,
                                        fontFamily: "Brandon",
                                        fontSize: 18),
                                    maxLines: 2,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.place,
                                        color: MYcolors.bluecolor,
                                      ),
                                      Flexible(
                                        child: Text(
                                          "${hospitals![i]!.address}",
                                          style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                              color: MYcolors.blacklightcolors,
                                              fontFamily: "Brandon",
                                              fontSize: 18),
                                          textAlign: TextAlign.center,
                                          maxLines: 3,
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }
            }
            return Center(child: Text("No Hospitals to show"),);
          }
        ),
      ),
    );
  }
}
