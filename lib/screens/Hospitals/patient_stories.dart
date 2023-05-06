// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/constants/colors.dart';

class Patient_page extends StatefulWidget {
  const Patient_page({super.key});

  @override
  State<Patient_page> createState() => _Patient_pageState();
}

class _Patient_pageState extends State<Patient_page> {
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
                Text(
                  "Patient's Stories",
                  style: TextStyle(
                    fontFamily: "Brandon",
                    fontSize: 22,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Divider(
            thickness: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                // color: MYcolors.greencolor,
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MYcolors.whitecolor,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "Images/P1.jpg",
                    ),
                  ),
                ),
                child: Icon(
                  Icons.image,
                  color: MYcolors.whitecolor,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                // color: MYcolors.greencolor,
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 0.40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MYcolors.whitecolor,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "Images/P2.jpg",
                    ),
                  ),
                ),
                child: Icon(
                  Icons.play_circle,
                  color: MYcolors.whitecolor,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                // color: MYcolors.greencolor,
                height: MediaQuery.of(context).size.height * 0.25,
                width: MediaQuery.of(context).size.width * 0.40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MYcolors.whitecolor,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "Images/P1.jpg",
                    ),
                  ),
                ),
                child: Icon(
                  Icons.image,
                  color: MYcolors.whitecolor,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
              Container(
                alignment: Alignment.bottomLeft,
                // color: MYcolors.greencolor,
                height: MediaQuery.of(context).size.height * 0.22,
                width: MediaQuery.of(context).size.width * 0.40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: MYcolors.whitecolor,
                  image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "Images/P2.jpg",
                    ),
                  ),
                ),
                child: Icon(
                  Icons.play_circle,
                  color: MYcolors.whitecolor,
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.02,
              ),
            ],
          )
        ],
      ),
    ));
  }
}
