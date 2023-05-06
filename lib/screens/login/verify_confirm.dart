// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/screens/login/complete_signup.dart';
import 'package:mmt_/screens/login/help_page.dart';

import '../../constants/colors.dart';

class Verify_Confirm_page extends StatefulWidget {
  const Verify_Confirm_page({super.key});

  @override
  State<Verify_Confirm_page> createState() => _Verify_Confirm_pageState();
}

class _Verify_Confirm_pageState extends State<Verify_Confirm_page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.04,
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
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Text(
                "Let's Verify",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.38,
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
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.0,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.08,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Text(
                  "We've send a verification code to 98*******90 and h****gmail.com",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MYcolors.greycolor,
                    borderRadius: BorderRadius.circular(8)),
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.23,
                child: Text(
                  "8",
                  style: TextStyle(fontSize: 50),
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MYcolors.greycolor,
                    borderRadius: BorderRadius.circular(8)),
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.23,
                child: Text(
                  "7",
                  style: TextStyle(fontSize: 50),
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MYcolors.greycolor,
                    borderRadius: BorderRadius.circular(8)),
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.23,
                child: Text(
                  "3",
                  style: TextStyle(fontSize: 50),
                ),
              ),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MYcolors.greycolor,
                    borderRadius: BorderRadius.circular(8)),
                height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.23,
                child: Text(
                  "6",
                  style: TextStyle(fontSize: 50),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.01,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.04,
              ),
              Text(
                "Resend",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: MYcolors.bluecolor),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
          ),
          GestureDetector(
            onTap: () {
              Get.to(Complete_Sign_Up_Page());
            },
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: MYcolors.bluecolor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "Verify",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MYcolors.whitecolor,
                    // fontFamily: "Brandon",
                    fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
