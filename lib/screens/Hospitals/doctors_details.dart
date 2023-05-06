// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/controller/controllers/doctor_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/screens/Hospitals/availble_treatment.dart';
import 'package:mmt_/screens/Hospitals/patient_stories.dart';
import 'package:mmt_/constants/colors.dart';

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
    return SafeArea(
        child: Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              width: double.infinity,
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
                height: MediaQuery.of(context).size.height * 0.6,
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
                        "Experience: ${controller.selectedDoctor!.experience} Years",
                        style: TextStyle(
                          // fontWeight: FontWeight.bold,
                            color: MYcolors.blacklightcolors,
                            fontFamily: "Brandon",
                            fontSize: 20),
                      ),
                      Text(
                        "Specializations: ${controller.selectedDoctor!.specialization}",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: MYcolors.blacklightcolors,
                            fontFamily: "Brandon",
                            fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}