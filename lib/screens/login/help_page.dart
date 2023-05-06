// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';

class Need_Help_page extends StatefulWidget {
  const Need_Help_page({super.key});

  @override
  State<Need_Help_page> createState() => _Need_Help_pageState();
}

class _Need_Help_pageState extends State<Need_Help_page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(children: [
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
              Text(
                "Need help?",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  // fontFamily: "Brandon",
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1.0,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: MYcolors.greycolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Container(
                    child: Text(
                      "Chat Support",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MYcolors.bluecolor,
                        // fontFamily: "Brandon",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "Get quick answer to any app-related queries from out team",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // color: MYcolors.bluecolor,
                    // fontFamily: "Brandon",
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: MYcolors.greycolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Container(
                    child: Text(
                      "Call us",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MYcolors.bluecolor,
                        // fontFamily: "Brandon",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "Get quick answer to any app-related queries from out team",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // color: MYcolors.bluecolor,
                    // fontFamily: "Brandon",
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
        Container(
          height: MediaQuery.of(context).size.height * 0.10,
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            color: MYcolors.greycolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.02,
                  ),
                  Container(
                    child: Text(
                      "Drop on email",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: MYcolors.bluecolor,
                        // fontFamily: "Brandon",
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "Get quick answer to any app-related queries from out team",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // color: MYcolors.bluecolor,
                    // fontFamily: "Brandon",
                    fontSize: 15,
                  ),
                ),
              )
            ],
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.01,
        ),
      ]),
    ));
  }
}
