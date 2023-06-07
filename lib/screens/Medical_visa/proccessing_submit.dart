// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Medical_visa/pay_page.dart';

import '../../constants/colors.dart';

class Proccessing_Submit_page extends StatefulWidget {
  const Proccessing_Submit_page({super.key});

  @override
  State<Proccessing_Submit_page> createState() =>
      _Proccessing_Submit_pageState();
}

class _Proccessing_Submit_pageState extends State<Proccessing_Submit_page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            CustomSpacer.l(),
            CustomSpacer.l(),
            Center(
              child: Icon(
                Icons.alarm,
                size: 80,
              ),
            ),
            CustomSpacer.m(),
            Text(
              "Please wait while we verify your\nuploaded documents",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            InkWell(
              onTap: () {
                Get.toNamed(Routes.home);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MYcolors.bluecolor),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Go Back to Home".tr,
                  style: TextStyle(
                    color: MYcolors.whitecolor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
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
