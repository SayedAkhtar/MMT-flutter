// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Video_consult/doctor_call.dart';

import '../../constants/colors.dart';

class Thank_you_page extends StatefulWidget {
  const Thank_you_page({super.key});

  @override
  State<Thank_you_page> createState() => _Thank_you_pageState();
}

class _Thank_you_pageState extends State<Thank_you_page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(CustomSpacer.S),
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Thank you !",
                style: TextStyle(
                  fontSize: 58,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Center(
                child: Text(
                  "We have received Your request for the video consultation.\nWe will consult with doctor and will inform you about his/her availability.\nIf not available in the said time slot we will arrange a new time which is convenient for both and let you know of the new time to get a confirmation.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Spacer(),
              GestureDetector(
                onTap: () {
                  Get.offAllNamed(Routes.home);
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: MYcolors.bluecolor),
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: Text(
                    "Home",
                    style: TextStyle(
                      color: MYcolors.whitecolor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
