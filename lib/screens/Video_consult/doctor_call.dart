// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/screens/Video_consult/doctor_call_chat.dart';
import 'package:MyMedTrip/screens/connects/chat_page.dart';

import '../../constants/colors.dart';

class Doctor_call_page extends StatefulWidget {
  const Doctor_call_page({super.key});

  @override
  State<Doctor_call_page> createState() => _Doctor_call_pageState();
}

class _Doctor_call_pageState extends State<Doctor_call_page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
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
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Container(
            // color: MYcolors.bluecolor,
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width * 0.4,
            child: Image.asset("Images/rrr.png"),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(
            "Dr.Abrar",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          Text(
            "To you previous request we have connect to",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "the doctor you asked for and now you can connect",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            "with him/her on 00/00/00 at 09:45 pm.",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.30,
          ),
          Text(
            "Or Want to Rechedule your video Consulation ?",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: MYcolors.greycolor),
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              "  Rechedule",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          GestureDetector(
            onTap: () {
              Get.to(Doctor_call_chat_page());
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: MYcolors.bluecolor),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "Connect",
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
    ));
  }
}
