// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/screens/connects/video_call_screen.dart';

import '../../constants/colors.dart';

class Video_call_page extends StatefulWidget {
  const Video_call_page({super.key});

  @override
  State<Video_call_page> createState() => _Video_call_pageState();
}

class _Video_call_pageState extends State<Video_call_page> {
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
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
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
            "Cordinator Name".tr,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Text(
            "calling.....",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
              ),
              GestureDetector(
                onTap: () {
                  Get.to(Video_Call_Screen());
                },
                child: Container(
                    padding: EdgeInsets.all(3),
                    height: MediaQuery.of(context).size.height * 0.07,
                    width: MediaQuery.of(context).size.width * 0.10,
                    // decoration: BoxDecoration(
                    //   color: MYcolors.greycolor,
                    //   borderRadius: BorderRadius.circular(100),
                    // ),
                    child: Image.asset(
                      "Images/VD.png",
                    )),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
              ),
              Container(
                  padding: EdgeInsets.all(3),
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.15,
                  decoration: BoxDecoration(
                      color: MYcolors.redcolor, shape: BoxShape.circle
                      // border: Border.
                      // borderRadius: BorderRadius.circular(100),
                      ),
                  child: Icon(
                    Icons.call_end,
                    color: MYcolors.whitecolor,
                  )),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.15,
              ),
              Container(
                  padding: EdgeInsets.all(3),
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.10,
                  // decoration: BoxDecoration(
                  //     color: MYcolors.redcolor, shape: BoxShape.circle
                  //     // border: Border.
                  //     // borderRadius: BorderRadius.circular(100),
                  //     ),
                  child: Image.asset(
                    "Images/CH.png",
                  )),
            ],
          )
        ],
      ),
    ));
  }
}
