// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/doctor_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/constants/colors.dart';

class Doctors_Details_page extends StatefulWidget {
  const Doctors_Details_page({super.key});

  @override
  State<Doctors_Details_page> createState() => _Doctors_Details_pageState();
}

class _Doctors_Details_pageState extends State<Doctors_Details_page> {
  late DoctorController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<DoctorController>();
  }
  @override
  Widget build(BuildContext context) {
    print(controller.selectedDoctor!.timeSlots);
    List timeSlots = [];
    // if(controller.selectedDoctor!.timeSlots!.isNotEmpty){
    //   controller.selectedDoctor!.timeSlots!.forEach((element) {
    //     timeSlots.add(element.dayName);
    //   });
    // }
    return Scaffold(
      appBar: CustomAppBar(pageName: "Doctor Details".tr, showDivider: true,),
      body: SizedBox(
    height: MediaQuery.of(context).size.height,
    width: double.infinity,
    child: Stack(
      children: [
        SizedBox(
          height: 100,
          width: double.infinity,
          child: Image.asset('assets/back-md.jpg', fit: BoxFit.fill,),
        ),
        SizedBox(
          height: 80,
          width: 80,
          child: Image.network(
            controller.selectedDoctor!.image!,
            fit: BoxFit.fill,
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: MYcolors.whitecolor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                  ), //BoxShadow
                  BoxShadow(
                    color: Colors.white,
                    offset: Offset(0.0, 0.0),
                    blurRadius: 0.0,
                    spreadRadius: 0.0,
                  ),
                ]),
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.all(CustomSpacer.S),
            child: SingleChildScrollView(
              child: Wrap(
                runSpacing: CustomSpacer.S,
                children: [
                  Text(
                    "${controller.selectedDoctor?.name}",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                        color: MYcolors.blacklightcolors,
                        fontFamily: "Brandon",
                        fontSize: 24),
                  ),
                  Row(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.place,
                        color: MYcolors.bluecolor,
                      ),
                      Text(
                        "${controller.selectedDoctor!.hospitals?.first.name}",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: MYcolors.blacklightcolors,
                            fontFamily: "Brandon",
                            fontSize: 20),
                      ),
                    ],
                  ),
                  Text(
                    "${"Experience:".tr} ${controller.selectedDoctor!.experience} ${"Years".tr}",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                        color: MYcolors.blacklightcolors,
                        fontFamily: "Brandon",
                        fontSize: 20),
                  ),
                  Text(
                    "${"Specializations:".tr} ${controller.selectedDoctor!.specialization}",
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: MYcolors.blacklightcolors,
                        fontFamily: "Brandon",
                        fontSize: 16),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      "${"Designation:".tr} ${controller.selectedDoctor!.designation}",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                          color: MYcolors.blacklightcolors,
                          fontFamily: "Brandon",
                          fontSize: 16),
                    ),
                  ),
                  Text(
                    "${"Qualification:".tr} ${controller.selectedDoctor!.qualification}",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                        color: MYcolors.blacklightcolors,
                        fontFamily: "Brandon",
                        fontSize: 16),
                  ),
                  Text(
                    "${"Video Consultation Availability:".tr} \n${timeSlots.join(', ')}",
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                        color: MYcolors.blacklightcolors,
                        fontFamily: "Brandon",
                        fontSize: 16),
                  ),
                  RichText(text: TextSpan(text: "${controller.selectedDoctor!.description}", style: TextStyle(color: Colors.black45)))
                ],
              ),
            ),
          ),
        ),
      ],
    ),
      ),
    );
  }
}
