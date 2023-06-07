// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/screens/Settings_page/help_page.dart';

class Login_fingerprint_page extends StatefulWidget {
  const Login_fingerprint_page({super.key});

  @override
  State<Login_fingerprint_page> createState() => _Login_fingerprint_pageState();
}

class _Login_fingerprint_pageState extends State<Login_fingerprint_page> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: size.height * 0.01,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: size.width * 0.04,
              ),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      color: MYcolors.greycolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.arrow_back_ios,
                      size: 20,
                    )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.73,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(Need_Help_page());
                },
                child: Container(
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.1,
                    decoration: BoxDecoration(
                      color: MYcolors.greycolor,
                      borderRadius: BorderRadius.circular(7),
                    ),
                    child: Icon(
                      Icons.question_mark_rounded,
                      size: 20,
                    )),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.09,
          ),
          Text(
            "Biometric Log in",
            style: TextStyle(fontFamily: "Brandon", fontSize: 23),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Icon(
            Icons.fingerprint,
            size: 60,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(
            "Touch the fingerprint sensor",
            style: TextStyle(
                fontFamily: "BrandonMed",
                fontSize: 15,
                color: MYcolors.blacklightcolors),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.55,
          ),
          GestureDetector(
            onTap: () {
            },
            child: Text(
              "Or sign in with password",
              style: TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 19,
                  color: MYcolors.bluecolor),
            ),
          ),
        ],
      ),
      // backgroundColor: MYcolors.greencolor,
    ));
  }
}
