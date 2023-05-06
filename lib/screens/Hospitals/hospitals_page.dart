// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/screens/Hospitals/hospital_preview.dart';
import 'package:mmt_/constants/colors.dart';

class Hospitals_page extends StatelessWidget {
  const Hospitals_page({super.key});

  @override
  Widget build(BuildContext context) {
    print(Get.parameters['id']);
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
                  width: MediaQuery.of(context).size.width * 0.05,
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
                Text(
                  "Hospitals",
                  style: TextStyle(
                    fontFamily: "Brandon",
                    fontSize: 25,
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          GestureDetector(
            onTap: () {
              Get.to(Hospital_preview_page());
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "Images/hos1.jpg",
                        ),
                      ),
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          // color: Color.fromARGB(255, 189, 181, 181),
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        )
                      ]),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  // color: MYcolors.greencolor,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Yasoda Hospital",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: MYcolors.blacklightcolors,
                            fontFamily: "Brandon",
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.place,
                            color: MYcolors.bluecolor,
                          ),
                          Text(
                            "87 Botsford",
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: MYcolors.blacklightcolors,
                                fontFamily: "Brandon",
                                fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          GestureDetector(
            onTap: () {
              Get.to(Hospital_preview_page());
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "Images/hos.png",
                        ),
                      ),
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          // color: Color.fromARGB(255, 189, 181, 181),
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        )
                      ]),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  // color: MYcolors.greencolor,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "KIMS Hospital",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: MYcolors.blacklightcolors,
                            fontFamily: "Brandon",
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.place,
                            color: MYcolors.bluecolor,
                          ),
                          Text(
                            "London",
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: MYcolors.blacklightcolors,
                                fontFamily: "Brandon",
                                fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          GestureDetector(
            onTap: () {
              Get.to(Hospital_preview_page());
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "Images/hos1.jpg",
                        ),
                      ),
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          // color: Color.fromARGB(255, 189, 181, 181),
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        )
                      ]),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  // color: MYcolors.greencolor,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "RLA Hospital",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: MYcolors.blacklightcolors,
                            fontFamily: "Brandon",
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.place,
                            color: MYcolors.bluecolor,
                          ),
                          Text(
                            "Greenland",
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: MYcolors.blacklightcolors,
                                fontFamily: "Brandon",
                                fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          GestureDetector(
            onTap: () {
              Get.to(Hospital_preview_page());
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "Images/hos.png",
                        ),
                      ),
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          // color: Color.fromARGB(255, 189, 181, 181),
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        )
                      ]),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  // color: MYcolors.greencolor,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "ISHU Hospital",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: MYcolors.blacklightcolors,
                            fontFamily: "Brandon",
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.place,
                            color: MYcolors.bluecolor,
                          ),
                          Text(
                            "Netherland",
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: MYcolors.blacklightcolors,
                                fontFamily: "Brandon",
                                fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          GestureDetector(
            onTap: () {
              Get.to(Hospital_preview_page());
            },
            child: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.35,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "Images/hos1.jpg",
                        ),
                      ),
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          // color: Color.fromARGB(255, 189, 181, 181),
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        )
                      ]),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.02,
                ),
                Container(
                  // color: MYcolors.greencolor,
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.12,
                  width: MediaQuery.of(context).size.width * 0.55,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Yasoda Hospital",
                        style: TextStyle(
                            // fontWeight: FontWeight.bold,
                            color: MYcolors.blacklightcolors,
                            fontFamily: "Brandon",
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.place,
                            color: MYcolors.bluecolor,
                          ),
                          Text(
                            "Nepal",
                            style: TextStyle(
                                // fontWeight: FontWeight.bold,
                                color: MYcolors.blacklightcolors,
                                fontFamily: "Brandon",
                                fontSize: 18),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
