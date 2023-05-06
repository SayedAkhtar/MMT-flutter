// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/controller/controllers/hospital_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/models/hospital_model.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Hospitals/availble_treatment.dart';
import 'package:mmt_/screens/Hospitals/doctors_details.dart';
import 'package:mmt_/screens/Hospitals/doctors_list.dart';
import 'package:mmt_/screens/Hospitals/patient_stories.dart';
import 'package:mmt_/constants/colors.dart';

class Hospital_preview_page extends GetView<HospitalController> {
  const Hospital_preview_page({super.key});

  @override
  Widget build(BuildContext context) {
    print(controller.selectedHospital!.name);
    // return Placeholder();
    return SafeArea(
      child: Scaffold(
        body: PageWithData(context, controller.selectedHospital!)
      ),
    );
  }

  Widget PageWithData(BuildContext context, Hospital hospital) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                hospital.logo??'https://via.placeholder.com/640x480.png/00eeaa?text=No%20Image',
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.6,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 24.0),
              decoration: BoxDecoration(
                  color: MYcolors.whitecolor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      blurRadius: 2,
                      spreadRadius: 0,
                      offset: Offset(0, 1),
                    ),
                  ]),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospital.name!,
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                          color: MYcolors.blacklightcolors,
                          fontFamily: "Brandon",
                          fontSize: 23),
                    ),
                    CustomSpacer.xs(),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.place,
                          color: MYcolors.bluecolor,
                        ),
                        Flexible(
                          child: Text(
                            hospital.address!,
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                                color: MYcolors.blacklightcolors,
                                fontFamily: "Brandon",
                                fontSize: 20),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                    CustomSpacer.s(),
                    Text(
                      "Other details",
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                          color: MYcolors.blacklightcolors,
                          fontFamily: "Brandon",
                          fontSize: 20),
                    ),
                    CustomSpacer.xs(),
                    Text(
                      hospital.description!,
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                          color: MYcolors.blacklightcolors,
                          fontFamily: "Brandon",
                          fontSize: 16),
                    ),
                    CustomSpacer.xs(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _hospitalFeatureButton(
                          context,
                          onTap: (){},
                          image: 'Images/blog.png', title: 'Blog',
                        ),
                        CustomSpacer.m(),
                        _hospitalFeatureButton(context,
                            onTap: () {
                              Get.toNamed(Routes.treatmentsAvailable);
                            },
                            image: "Images/Tr.png",
                            title: "Available Treatment"
                        ),
                      ],
                    ),
                    CustomSpacer.m(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _hospitalFeatureButton(
                          context,
                        onTap: () {
                          Get.toNamed(Routes.patientTestimony);
                        },
                          image: "Images/Md.png", title: "Patient testimonials",
                        ),
                        CustomSpacer.m(),
                        _hospitalFeatureButton(
                          context,
                          onTap: () {
                            Get.toNamed(Routes.doctors, arguments: {'type': 'doctorByHospital', "hospital_id": hospital.id});
                          },
                          image: "Images/St.png", title: "Doctors",
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _hospitalFeatureButton(BuildContext context,
      {required VoidCallback onTap, required String image, required String title}){
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0) ,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: MYcolors.greycolor
          ),
          height: MediaQuery.of(context).size.height * 0.10,
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    image,
                    height: 40,
                    width: 40,
                    // fit: BoxFit.fill,
                  ),
                  Text(
                    title,
                    style: TextStyle(
                      // fontWeight: FontWeight.bold,
                        color: MYcolors.blackcolor,
                        fontFamily: "Brandon",
                        fontSize: 15),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}