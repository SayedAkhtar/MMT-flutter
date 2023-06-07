// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Medical_visa/terms_and_conditions.dart';

import '../../constants/colors.dart';

class Proccessing_page extends StatelessWidget {
  const Proccessing_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Expanded(child:
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const[
                    Icon(
                      Icons.alarm,
                      size: 80,
                    ),
                    Text(
                      "Please wait while we verify your\nuploaded documents",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ),
            GestureDetector(
              onTap: () {
                Get.offAllNamed(Routes.home);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MYcolors.greycolor),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Proceed".tr,
                  style: TextStyle(
                    color: MYcolors.greylightcolor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
