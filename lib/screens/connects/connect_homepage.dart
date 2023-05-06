// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/screens/Video_consult/shedule.dart';
import 'package:mmt_/screens/connects/calls_page.dart';
import 'package:mmt_/screens/connects/chat_page.dart';
import 'package:mmt_/screens/connects/messages_page.dart';

import '../../constants/colors.dart';

class Connect_Home_page extends StatefulWidget {
  const Connect_Home_page({super.key});

  @override
  State<Connect_Home_page> createState() => _Connect_Home_pageState();
}

class _Connect_Home_pageState extends State<Connect_Home_page> {
  int currentindex = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(pageName: "Teleconsultation History", showDivider: true, showBack: false,),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: MYcolors.greycolor,
              borderRadius: BorderRadius.circular(10),
            ),
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentindex = 0;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: currentindex == 0
                          ? MYcolors.whitecolor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Text(
                      "Calls".tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontFamily: "Brandon",
                          fontSize: 15,
                          color: MYcolors.blacklightcolors),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      currentindex = 1;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: currentindex == 1
                          ? MYcolors.whitecolor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: MediaQuery.of(context).size.height * 0.04,
                    width: MediaQuery.of(context).size.width * 0.38,
                    child: Text(
                      "Messages".tr,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          // fontFamily: "Brandon",
                          fontSize: 15,
                          color: MYcolors.blacklightcolors),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
          IndexedStack(
            index: currentindex,
            children: [
              Calls_Page(),
              Messages_pages(),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.01,
          ),
        ],
      ),
    ));
  }
}
