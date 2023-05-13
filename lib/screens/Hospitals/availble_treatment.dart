// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/constants/colors.dart';
import 'package:mmt_/controller/controllers/hospital_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';

class Available_Treatment extends GetView<HospitalController> {
  const Available_Treatment({super.key});

  @override
  Widget build(BuildContext context) {
    // print(controller.selectedHospital?.treatment?.first.name);
    if(controller.selectedHospital != null
        && controller.selectedHospital!.treatment != null
        && controller.selectedHospital!.treatment!.isNotEmpty){
      return Scaffold(
        appBar: CustomAppBar(pageName: "Available Treatment", showDivider: true,),
        body: Padding(
          padding: const EdgeInsets.all(CustomSpacer.S),
          child: ListView.builder(
            itemCount: controller.selectedHospital!.treatment!.length,
              itemBuilder: (ctx, i){
                return Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(
                            " ${controller.selectedHospital!.treatment![i].name}",
                            style: TextStyle(
                              fontFamily: "Brandon",
                              fontSize: 18,
                            ),
                          )),
                      Row(
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.05,
                            width: MediaQuery.of(context).size.width * 0.05,
                            child: Image.asset(
                              "Images/dollar.png",
                              color: MYcolors.bluecolor,
                              // fit: BoxFit.fill,
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.01,
                          ),
                          Text(
                            "${controller.selectedHospital!.treatment![i].price}",
                            style: TextStyle(
                              fontFamily: "BrandonMed",
                              fontSize: 15,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                );
              }
          ),
        ),
      );
    }
    return Scaffold(
        appBar: CustomAppBar(pageName: "Available Treatment", showDivider: true,),
        body: Center(child: Text("No treatment added for this hospital yet."),)
    );
  }
}
