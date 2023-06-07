// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/controller/controllers/hospital_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';

class Patient_page extends StatelessWidget {
  const Patient_page({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HospitalController>();
    if(controller.selectedHospital != null
        && controller.selectedHospital!.testimony != null
        && controller.selectedHospital!.testimony!.isNotEmpty){
      return Scaffold(
        appBar: CustomAppBar(pageName: "Patient Testimonies", showDivider: true,),
        body: Padding(
          padding: EdgeInsets.all(CustomSpacer.S),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1 / 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: controller.selectedHospital!.testimony!.length,
              itemBuilder: (ctx, i){
                return Container(
                  alignment: Alignment.bottomLeft,
                  // color: MYcolors.greencolor,
                  height: MediaQuery.of(context).size.height * 0.25,
                  width: MediaQuery.of(context).size.width * 0.40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: MYcolors.whitecolor,
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(
                        controller.selectedHospital!.testimony![i].value!,
                      ),
                    ),
                  ),
                  child: Icon(
                    Icons.image,
                    color: MYcolors.whitecolor,
                  ),
                );
              }),
        ),
      );
    }
    return Scaffold(
        appBar: CustomAppBar(pageName: "Patient Testimonies", showDivider: true,),
      body: Center(child: Text("No testimony added for this hospital yet."),)
    );
  }
}
