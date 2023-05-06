// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/connects/chat_page.dart';

import '../../constants/colors.dart';

class Calls_Page extends StatefulWidget {
  const Calls_Page({super.key});

  @override
  State<Calls_Page> createState() => _Calls_PageState();
}

class _Calls_PageState extends State<Calls_Page> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.videoChat);
          },
          child: Container(
            // color: MYcolors.bluecolor,
            height: MediaQuery.of(context).size.height * 0.07,
            // width: MediaQuery.of(context).size.width * 0.38,
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  decoration: BoxDecoration(
                    // color: MYcolors.bluecolor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  height: MediaQuery.of(context).size.height * 0.07,
                  width: MediaQuery.of(context).size.width * 0.15,
                  child: Image.asset(
                    "Images/PR.png",
                    // fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Madhu",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontFamily: "Brandon",
                          fontSize: 15,
                          color: MYcolors.blacklightcolors),
                    ),
                    Text(
                      "Outgoing call".tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontFamily: "Brandon",
                          fontSize: 15,
                          color: MYcolors.greencolor),
                    )
                  ],
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.37,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("05:02 PM"),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.005,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          // color: MYcolors.bluecolor,
          height: MediaQuery.of(context).size.height * 0.07,
          // width: MediaQuery.of(context).size.width * 0.38,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  "Images/PR.png",
                  // fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pavan",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  Text(
                    "Missed call".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.redcolor),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.41,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("05:02 PM"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          // color: MYcolors.bluecolor,
          height: MediaQuery.of(context).size.height * 0.07,
          // width: MediaQuery.of(context).size.width * 0.38,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  "Images/PR.png",
                  // fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Sridhar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  Text(
                    "Outgoing call".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.greencolor),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.37,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("05:02 PM"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          // color: MYcolors.bluecolor,
          height: MediaQuery.of(context).size.height * 0.07,
          // width: MediaQuery.of(context).size.width * 0.38,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  "Images/PR.png",
                  // fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Kamalesh",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  Text(
                    "Missed call".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.redcolor),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.41,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("05:02 PM"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                ],
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          // color: MYcolors.bluecolor,
          height: MediaQuery.of(context).size.height * 0.07,
          // width: MediaQuery.of(context).size.width * 0.38,
          child: Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                decoration: BoxDecoration(
                  // color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                height: MediaQuery.of(context).size.height * 0.07,
                width: MediaQuery.of(context).size.width * 0.15,
                child: Image.asset(
                  "Images/PR.png",
                  // fit: BoxFit.fill,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.03,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Abrar",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  Text(
                    "Missed call".tr,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        // fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.redcolor),
                  )
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.41,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("05:02 PM"),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.005,
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
