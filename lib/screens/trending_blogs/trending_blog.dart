// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/screens/trending_blogs/read_blog.dart';

class Trending_blog_page extends StatefulWidget {
  const Trending_blog_page({super.key});

  @override
  State<Trending_blog_page> createState() => _Trending_blog_pageState();
}

class _Trending_blog_pageState extends State<Trending_blog_page> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        // backgroundColor: MYcolors.blackcolor,
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
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
                      width: MediaQuery.of(context).size.width * 0.04,
                    ),
                    Text(
                      "Trending Blogs",
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
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.49,
                    width: MediaQuery.of(context).size.width * 0.92,
                    decoration: BoxDecoration(
                        //
                        color: MYcolors.whitecolor,
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: MYcolors.blackcolor),
                        boxShadow: [
                          BoxShadow(
                            // /color: Color.fromARGB(255, 189, 181, 181),
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                          )
                        ]),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.01,
                        // ),
                        Container(
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // image: DecorationImage(image: ),
                            color: MYcolors.greycolor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Image.asset(
                            "Images/hos.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    //
                                    color: MYcolors.bluecolor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        // /color: Color.fromARGB(255, 189, 181, 181),
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        spreadRadius: 0,
                                        offset: Offset(0, 1),
                                      )
                                    ]),
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.20,
                                // color: MYcolors.greencolor,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                      "03",
                                      style: TextStyle(
                                          fontFamily: "BrandonMed",
                                          fontSize: 19,
                                          color: MYcolors.whitecolor),
                                    ),
                                    Text(
                                      "Oct",
                                      style: TextStyle(
                                          fontFamily: "BrandonMed",
                                          fontSize: 19,
                                          color: MYcolors.whitecolor),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.07,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      "Our latest blog",
                                      style: TextStyle(
                                          fontFamily: "Brandon",
                                          fontSize: 19,
                                          color: MYcolors.blackcolor),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    // height: MediaQuery.of(context).size.height * 0.10,
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      "lorem ipsum is simply dummy text of the printing and typesetting industry ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "BrandonReg",
                                          fontSize: 14,
                                          color: MYcolors.blackcolor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Get.to(ReadBlogPage("title", "description"));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                width: MediaQuery.of(context).size.width * 0.18,
                                decoration: BoxDecoration(
                                    //
                                    color: MYcolors.whitecolor,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: MYcolors.blacklightcolors),
                                    boxShadow: [
                                      // BoxShadow(
                                      //   // /color: Color.fromARGB(255, 189, 181, 181),
                                      //   color: Colors.grey.withOpacity(0.5),
                                      //   blurRadius: 2,
                                      //   spreadRadius: 0,
                                      //   offset: Offset(0, 1),
                                      // )
                                    ]),
                                child: Text("Read"),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.49,
                    width: MediaQuery.of(context).size.width * 0.92,
                    decoration: BoxDecoration(
                        //
                        color: MYcolors.whitecolor,
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: MYcolors.blackcolor),
                        boxShadow: [
                          BoxShadow(
                            // /color: Color.fromARGB(255, 189, 181, 181),
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                          )
                        ]),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.01,
                        // ),
                        Container(
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // image: DecorationImage(image: ),
                            color: MYcolors.greycolor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Image.asset(
                            "Images/hos.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    //
                                    color: MYcolors.bluecolor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        // /color: Color.fromARGB(255, 189, 181, 181),
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        spreadRadius: 0,
                                        offset: Offset(0, 1),
                                      )
                                    ]),
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.20,
                                // color: MYcolors.greencolor,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                      "03",
                                      style: TextStyle(
                                          fontFamily: "BrandonMed",
                                          fontSize: 19,
                                          color: MYcolors.whitecolor),
                                    ),
                                    Text(
                                      "Oct",
                                      style: TextStyle(
                                          fontFamily: "BrandonMed",
                                          fontSize: 19,
                                          color: MYcolors.whitecolor),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.07,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      "Our latest blog",
                                      style: TextStyle(
                                          fontFamily: "Brandon",
                                          fontSize: 19,
                                          color: MYcolors.blackcolor),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    // height: MediaQuery.of(context).size.height * 0.10,
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      "lorem ipsum is simply dummy text of the printing and typesetting industry ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "BrandonReg",
                                          fontSize: 14,
                                          color: MYcolors.blackcolor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Get.to(Read_blog_page());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                width: MediaQuery.of(context).size.width * 0.18,
                                decoration: BoxDecoration(
                                    //
                                    color: MYcolors.whitecolor,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: MYcolors.blacklightcolors),
                                    boxShadow: [
                                      // BoxShadow(
                                      //   // /color: Color.fromARGB(255, 189, 181, 181),
                                      //   color: Colors.grey.withOpacity(0.5),
                                      //   blurRadius: 2,
                                      //   spreadRadius: 0,
                                      //   offset: Offset(0, 1),
                                      // )
                                    ]),
                                child: Text("Read"),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
              Row(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.05,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.49,
                    width: MediaQuery.of(context).size.width * 0.92,
                    decoration: BoxDecoration(
                        //
                        color: MYcolors.whitecolor,
                        borderRadius: BorderRadius.circular(10),
                        // border: Border.all(color: MYcolors.blackcolor),
                        boxShadow: [
                          BoxShadow(
                            // /color: Color.fromARGB(255, 189, 181, 181),
                            color: Colors.grey.withOpacity(0.5),
                            blurRadius: 2,
                            spreadRadius: 0,
                            offset: Offset(0, 1),
                          )
                        ]),
                    child: Column(
                      children: [
                        // SizedBox(
                        //   height: MediaQuery.of(context).size.height * 0.01,
                        // ),
                        Container(
                          // alignment: Alignment.center,
                          decoration: BoxDecoration(
                            // image: DecorationImage(image: ),
                            color: MYcolors.greycolor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10)),
                          ),
                          child: Image.asset(
                            "Images/hos.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.01,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.01,
                            ),
                            Container(
                                decoration: BoxDecoration(
                                    //
                                    color: MYcolors.bluecolor,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        // /color: Color.fromARGB(255, 189, 181, 181),
                                        color: Colors.grey.withOpacity(0.5),
                                        blurRadius: 2,
                                        spreadRadius: 0,
                                        offset: Offset(0, 1),
                                      )
                                    ]),
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.12,
                                width: MediaQuery.of(context).size.width * 0.20,
                                // color: MYcolors.greencolor,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.01,
                                    ),
                                    Text(
                                      "03",
                                      style: TextStyle(
                                          fontFamily: "BrandonMed",
                                          fontSize: 19,
                                          color: MYcolors.whitecolor),
                                    ),
                                    Text(
                                      "Oct",
                                      style: TextStyle(
                                          fontFamily: "BrandonMed",
                                          fontSize: 19,
                                          color: MYcolors.whitecolor),
                                    ),
                                  ],
                                )),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.07,
                            ),
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.04,
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      "Our latest blog",
                                      style: TextStyle(
                                          fontFamily: "Brandon",
                                          fontSize: 19,
                                          color: MYcolors.blackcolor),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    // height: MediaQuery.of(context).size.height * 0.10,
                                    width: MediaQuery.of(context).size.width *
                                        0.50,
                                    child: Text(
                                      "lorem ipsum is simply dummy text of the printing and typesetting industry ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "BrandonReg",
                                          fontSize: 14,
                                          color: MYcolors.blackcolor),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                // Get.to(Read_blog_page());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.04,
                                width: MediaQuery.of(context).size.width * 0.18,
                                decoration: BoxDecoration(
                                    //
                                    color: MYcolors.whitecolor,
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: MYcolors.blacklightcolors),
                                    boxShadow: [
                                      // BoxShadow(
                                      //   // /color: Color.fromARGB(255, 189, 181, 181),
                                      //   color: Colors.grey.withOpacity(0.5),
                                      //   blurRadius: 2,
                                      //   spreadRadius: 0,
                                      //   offset: Offset(0, 1),
                                      // )
                                    ]),
                                child: Text("Read"),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
              )
            ],
          ),
        ),
      ),
    );
  }
}
