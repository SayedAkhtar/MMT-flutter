// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/constants/colors.dart';

class FAQS_Page extends StatefulWidget {
  const FAQS_Page({super.key});

  @override
  State<FAQS_Page> createState() => _FAQS_PageState();
}

class _FAQS_PageState extends State<FAQS_Page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: MYcolors.blackcolor,
        body: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
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
                    "FAQs".tr,
                    style: TextStyle(
                      fontFamily: "Brandon",
                      fontSize: 25,
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
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.04,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  //
                  color: MYcolors.whitecolor,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: MYcolors.blacklightcolors, width: 0.5)),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Text(
                "Lorem Ips is simply dummy text >",
                style: TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  //
                  color: MYcolors.whitecolor,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: MYcolors.blacklightcolors, width: 0.5),
                  boxShadow: const [
                    // BoxShadow(
                    //   // /color: Color.fromARGB(255, 189, 181, 181),
                    //   color: Colors.grey.withOpacity(0.5),
                    //   blurRadius: 2,
                    //   spreadRadius: 0,
                    //   offset: Offset(0, 1),
                    // )
                  ]),
              // margin: EdgeInsets.only(left: 2),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Text(
                "Lorem Ips is simply dummy text >",
                style: TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  //
                  color: MYcolors.whitecolor,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: MYcolors.blacklightcolors, width: 0.5),
                  boxShadow: const [
                    // BoxShadow(
                    //   // /color: Color.fromARGB(255, 189, 181, 181),
                    //   color: Colors.grey.withOpacity(0.5),
                    //   blurRadius: 2,
                    //   spreadRadius: 0,
                    //   offset: Offset(0, 1),
                    // )
                  ]),
              // margin: EdgeInsets.only(left: 2),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Text(
                "Lorem Ips is simply dummy text >",
                style: TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  //
                  color: MYcolors.whitecolor,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: MYcolors.blacklightcolors, width: 0.5),
                  boxShadow: const [
                    // BoxShadow(
                    //   // /color: Color.fromARGB(255, 189, 181, 181),
                    //   color: Colors.grey.withOpacity(0.5),
                    //   blurRadius: 2,
                    //   spreadRadius: 0,
                    //   offset: Offset(0, 1),
                    // )
                  ]),
              // margin: EdgeInsets.only(left: 2),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Text(
                "Lorem Ips is simply dummy text >",
                style: TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  //
                  color: MYcolors.whitecolor,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: MYcolors.blacklightcolors, width: 0.5),
                  boxShadow: const [
                    // BoxShadow(
                    //   // /color: Color.fromARGB(255, 189, 181, 181),
                    //   color: Colors.grey.withOpacity(0.5),
                    //   blurRadius: 2,
                    //   spreadRadius: 0,
                    //   offset: Offset(0, 1),
                    // )
                  ]),
              // margin: EdgeInsets.only(left: 2),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Text(
                "Lorem Ips is simply dummy text >",
                style: TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  //
                  color: MYcolors.whitecolor,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: MYcolors.blacklightcolors, width: 0.5),
                  boxShadow: const [
                    // BoxShadow(
                    //   // /color: Color.fromARGB(255, 189, 181, 181),
                    //   color: Colors.grey.withOpacity(0.5),
                    //   blurRadius: 2,
                    //   spreadRadius: 0,
                    //   offset: Offset(0, 1),
                    // )
                  ]),
              // margin: EdgeInsets.only(left: 2),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Text(
                "Lorem Ips is simply dummy text >",
                style: TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 15,
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  //
                  color: MYcolors.whitecolor,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: MYcolors.blacklightcolors, width: 0.5),
                  boxShadow: const [
                    // BoxShadow(
                    //   // /color: Color.fromARGB(255, 189, 181, 181),
                    //   color: Colors.grey.withOpacity(0.5),
                    //   blurRadius: 2,
                    //   spreadRadius: 0,
                    //   offset: Offset(0, 1),
                    // )
                  ]),
              // margin: EdgeInsets.only(left: 2),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width * 0.95,
              child: Text(
                "Lorem Ips is simply dummy text >",
                style: TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
