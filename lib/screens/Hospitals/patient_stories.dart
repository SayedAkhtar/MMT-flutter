// ignore_for_file: prefer_const_constructors

import 'package:MyMedTrip/screens/stories/patient_stories.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/controller/controllers/hospital_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';

import '../../constants/home_model.dart';

class Patient_page extends StatelessWidget {
  Patient_page({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Stories>? stories = Get.arguments;
    if(stories!.isNotEmpty){
      return Scaffold(
        appBar: CustomAppBar(pageName: "Patient Testimonies".tr, showDivider: true,),
        body: Padding(
          padding: EdgeInsets.all(CustomSpacer.S),
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1 / 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: stories.length,
              itemBuilder: (ctx, i){
                return GestureDetector(
                  onTap: (){
                    Get.to(() => PatientStories(
                      stories[i].description!,
                      stories[i].thumbnail!,
                      images: stories[i].images!,
                      videos: stories[i].videos!,
                    ));
                  },
                  child: Container(
                    alignment: Alignment.bottomLeft,
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: MediaQuery.of(context).size.width * 0.40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MYcolors.whitecolor,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: NetworkImage(
                          stories[i].thumbnail!,
                        ),
                      ),
                    ),
                    child: Icon(
                      Icons.image,
                      color: MYcolors.whitecolor,
                    ),
                  ),
                );
              }),
        ),
      );
    }
    return Scaffold(
        appBar: CustomAppBar(pageName: "Patient Testimonies".tr, showDivider: true,),
      body: Center(child: Text("No testimony added for this hospital yet.".tr),)
    );
  }
}
