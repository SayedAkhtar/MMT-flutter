// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:MyMedTrip/components/ImageWithLoader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/hospital_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/models/hospital_model.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Hospitals/availble_treatment.dart';
import 'package:MyMedTrip/screens/Hospitals/doctors_details.dart';
import 'package:MyMedTrip/screens/Hospitals/doctors_list.dart';
import 'package:MyMedTrip/screens/Hospitals/patient_stories.dart';
import 'package:MyMedTrip/constants/colors.dart';

class Hospital_preview_page extends GetView<HospitalController> {
  const Hospital_preview_page({super.key});

  @override
  Widget build(BuildContext context) {
    // return Placeholder();
    return Scaffold(
      appBar: CustomAppBar(pageName: controller.selectedHospital!.name!,),
      body: PageWithData(context, controller.selectedHospital!)
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
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              child: ImageWithLoader(imageUrl: hospital.logo!,),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.45,
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
                    CustomSpacer.xs(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _hospitalFeatureButton(
                          context,
                          onTap: (){},
                          image: 'Images/blog.png', title: 'Blog',
                        ),
                        CustomSpacer.s(),
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
                        CustomSpacer.s(),
                        _hospitalFeatureButton(
                          context,
                          onTap: () {
                            Get.toNamed(Routes.doctors, arguments: {'type': 'doctorByHospital', "hospital_id": hospital.id});
                          },
                          image: "Images/St.png", title: "Doctors",
                        ),
                      ],
                    ),
                    CustomSpacer.l(),
                    Text(
                      hospital.description!,
                      style: TextStyle(
                        // fontWeight: FontWeight.bold,
                          color: MYcolors.blacklightcolors,
                          fontFamily: "Brandon",
                          fontSize: 16),
                    ),


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
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                          color: MYcolors.blackcolor,
                          fontFamily: "Brandon",
                          fontSize: 15),
                    ),
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
