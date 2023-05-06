import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomCardWithImage.dart';
import 'package:mmt_/components/MarginBox.dart';
import 'package:mmt_/components/TextButtonWithIcon.dart';
import 'package:mmt_/controller/controllers/doctor_controller.dart';
import 'package:mmt_/controller/controllers/home_controller.dart';
import 'package:mmt_/controller/controllers/hospital_controller.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/helper/Utils.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/constants/colors.dart';
import 'package:mmt_/screens/Home_screens/SearchScreen.dart';
import 'package:mmt_/screens/trending_blogs/read_blog.dart';
import 'package:mmt_/screens/trending_blogs/trending_blog.dart';

import '../../components/Heading.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController _homeController;
  late DoctorController _doctorController;
  late HospitalController _hospitalController;
  late UserController _userController;
  late DateTime currentBackPressTime;
  @override
  void initState() {
    super.initState();
    _homeController = Get.find<HomeController>();
    _doctorController = Get.find<DoctorController>();
    _hospitalController = Get.find<HospitalController>();
    _userController = Get.find<UserController>();
    _homeController.getHomeData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (now.difference(currentBackPressTime) > Duration(seconds: 2)) {
          currentBackPressTime = now;
          Get.showSnackbar(
            GetSnackBar(
              title: "Are you sure you want to exit ?",
              message: "Click back button twice to exit the app.",
              duration: Duration(milliseconds: 2500),
            ),
          );
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                SizedBox(
                  height: 100,
                  child: Row(children: [
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.setting);
                      },
                      child: Image.asset(
                        "Images/PR.png",
                        // fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      "Hi, ${_userController.user != null ? _userController.user!.name : 'Name'}",
                      style: TextStyle(
                          fontFamily: "BrandonMed",
                          fontSize: 20,
                          color: MYcolors.blacklightcolors),
                    ),
                  ]),
                ),
                MarginBox(child: Obx(() {
                  if (_homeController.isLoading.value) {
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _homeController.banners.length,
                          itemBuilder: (_, index) {
                            return Container(
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(right: 20.0),
                              decoration: BoxDecoration(),
                              child: Image.network(
                                _homeController.banners[index],
                                fit: BoxFit.cover,
                              ),
                            );
                          }),
                    );
                  }
                  return SizedBox();
                })),
                //----- Search Bar
                MarginBox(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => SearchScreen());
                    },
                    child: Container(
                      padding: EdgeInsets.all(CustomSpacer.S),
                      decoration: BoxDecoration(
                          color: MYcolors.whitecolor,
                          borderRadius: BorderRadius.circular(100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 2,
                              spreadRadius: 0,
                              offset: Offset(0, 1),
                            )
                          ]),
                      height: CustomSpacer.M * 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.search_rounded),
                          CustomSpacer.s(),
                          Text('Search for doctors and hospitals'.tr)
                        ],
                      ),
                    ),
                  ),
                ),
                // ---- Main Action Bar
                MarginBox(
                  child: Container(
                    decoration: BoxDecoration(
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.startQuery);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset(
                                  "assets/icons/generate-query.svg"),
                              Text(
                                "Generate \nQuery".tr,
                                style: TextStyle(
                                    fontFamily: "Brandon", color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.teleconsultationSchedule);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset("assets/icons/video.svg"),
                              Text(
                                "Video \nConsultation".tr,
                                style: TextStyle(
                                    fontFamily: "Brandon", color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.toNamed(Routes.activeQueryUploadVisa);
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: Column(
                            children: [
                              SvgPicture.asset("assets/icons/medical-visa.svg"),
                              Text(
                                "Medical \nvisa".tr,
                                style: TextStyle(
                                    fontFamily: "Brandon", color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                MarginBox(
                  child: _rowHeader(context, "Suggested Hospitals", () {}),
                ),
                Container(
                  height: 240,
                  child: Obx(
                    () => _homeController.isLoading.value
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _homeController.hospitals.length,
                            itemBuilder: (_, index) {
                              return CustomCardWithImage(
                                onTap: () {
                                  _hospitalController.openHospitalDetails(
                                      _homeController.hospitals[index].id!);
                                },
                                imageUri: _homeController.hospitals[index].logo,
                                title: _homeController.hospitals[index].name,
                                bodyText:
                                    _homeController.hospitals[index].address,
                                icon: Icons.pin_drop,
                              );
                            })
                        : SizedBox(),
                  ),
                ),
                _rowHeader(context, "Suggested Doctors", () {
                  Get.toNamed(Routes.doctors, arguments: {'type': 'allDoctor'});
                }),
                Container(
                  height: 240,
                  margin: EdgeInsets.only(bottom: 16.0),
                  child: Obx(
                    () => _homeController.isLoading.value
                        ? ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _homeController.doctors.length,
                            itemBuilder: (_, index) {
                              return CustomCardWithImage(
                                onTap: () {
                                  _doctorController.openDoctorsDetailsPage(
                                      _homeController.doctors[index].id);
                                },
                                imageUri:
                                    _homeController.doctors[index].avatar!,
                                title: _homeController.doctors[index].name!,
                                bodyText:
                                    " ${_homeController.doctors[index].exp!} \n ${_homeController.doctors[index].specialization!}",
                                align: TextAlign.center,
                              );
                            })
                        : SizedBox(),
                  ),
                ),
                CustomSpacer.s(),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      //
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: MYcolors.blackcolor),
                      boxShadow: [
                        BoxShadow(
                          // /color: Color.fromARGB(255, 189, 181, 181),
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        )
                      ]),
                  // margin: EdgeInsets.only(left: 2),
                  height: MediaQuery.of(context).size.height * 0.09,
                  width: MediaQuery.of(context).size.width * 0.95,
                  child: Text(
                    "Need help from where to start? talk us.".tr,
                    style: const TextStyle(
                      fontFamily: "Brandon",
                      fontSize: 15,
                    ),
                  ),
                ),
                CustomSpacer.s(),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: CustomSpacer.XS),
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          MYcolors.greenlightcolor,
                          MYcolors.bluecolor,
                        ],
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
                  // margin: EdgeInsets.only(left: 2),
                  height: 60,
                  child: Text(
                    "wellness centers".tr,
                    style: const TextStyle(
                        fontFamily: "Brandon",
                        fontSize: 20,
                        color: MYcolors.whitecolor),
                  ),
                ),
                CustomSpacer.s(),
                _rowHeader(context, "Our latest blog", () {
                  // Get.toNamed(Routes.doctors, arguments: {'type': 'allDoctor'});
                }),
                FutureBuilder(
                    future: _homeController.getBlogData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done &&
                          snapshot.hasData) {
                        Response res = snapshot.data!;
                        List obj = res.body;
                        return SizedBox(
                          height: 430,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: obj.length,
                              itemBuilder: (_, index) {
                                var _date = DateTime.parse(obj[index]['date']);
                                return GestureDetector(
                                  onTap: (){
                                    Get.to(() => ReadBlogPage(
                                        obj[index]['title']['rendered'],
                                        obj[index]['content']['rendered'],
                                        obj[index]['fimg_url']
                                    )
                                    );
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width - 40,
                                    child: Card(
                                      clipBehavior: Clip.hardEdge,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 230,
                                            child: Image.network(
                                              obj[index]['fimg_url'],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      right: CustomSpacer.XS,
                                                      left: CustomSpacer.XS),
                                                  decoration: BoxDecoration(
                                                      color: MYcolors.bluecolor,
                                                      borderRadius: BorderRadius.circular(10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey.withOpacity(0.5),
                                                          blurRadius: 2,
                                                          spreadRadius: 0,
                                                          offset: Offset(0, 1),
                                                        )
                                                      ]),
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context).size.width * 0.20,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${_date.day}",
                                                        style: const TextStyle(
                                                            fontFamily: "BrandonMed",
                                                            fontSize: 19,
                                                            color: MYcolors.whitecolor),
                                                      ),
                                                      Text(
                                                        Utils.getMonthShortName(_date.month),
                                                        style: const TextStyle(
                                                            fontFamily: "BrandonMed",
                                                            fontSize: 19,
                                                            color: MYcolors.whitecolor),
                                                      ),
                                                    ],
                                                  )),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${obj[index]['title']['rendered']}",
                                                      maxLines: 3,
                                                      style: const TextStyle(
                                                          fontFamily: "Brandon",
                                                          fontSize: 19,
                                                          color: MYcolors.blackcolor, overflow: TextOverflow.ellipsis),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "${obj[index]['excerpt']['rendered']}",
                                                        maxLines: 3,
                                                        style: const TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontFamily: "BrandonReg",
                                                            fontSize: 14,
                                                            color: MYcolors.blackcolor,
                                                            overflow: TextOverflow.ellipsis),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(right: CustomSpacer.XS),
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Get.to(() => ReadBlogPage(
                                                    obj[index]['title']['rendered'],
                                                    obj[index]['content']['rendered'],
                                                    obj[index]['fimg_url']
                                                )
                                                );
                                              },
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor: MYcolors.blacklightcolors,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(100)),
                                              ),
                                              child: Text('Explore'),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                      return CircularProgressIndicator();
                    }),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text(
                      "Not convinced ?".tr,
                      style: TextStyle(
                          fontFamily: "Brandon",
                          fontSize: 19,
                          color: MYcolors.blackcolor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.02,
                    ),
                    Text(
                      "Check out some of our Patient's stories.".tr,
                      style: TextStyle(
                          fontFamily: "Brandon",
                          fontSize: 18,
                          color: MYcolors.blacklightcolors),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                        // color: MYcolors.greencolor,
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.22,
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
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                        // color: MYcolors.greencolor,
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.22,
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
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                        // color: MYcolors.greencolor,
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.22,
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
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                        // color: MYcolors.greencolor,
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.22,
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
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.02,
                      ),
                      Container(
                        // color: MYcolors.greencolor,
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.22,
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
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                _rowHeader(context, "FAQs", () {
                  Get.toNamed(Routes.faq);
                }),

                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      //
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: MYcolors.blacklightcolors, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          // /color: Color.fromARGB(255, 189, 181, 181),
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        )
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
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      //
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: MYcolors.blacklightcolors, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          // /color: Color.fromARGB(255, 189, 181, 181),
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        )
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
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      //
                      color: MYcolors.whitecolor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: MYcolors.blacklightcolors, width: 0.5),
                      boxShadow: [
                        BoxShadow(
                          // /color: Color.fromARGB(255, 189, 181, 181),
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: Offset(0, 1),
                        )
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
                  height: MediaQuery.of(context).size.height * 0.03,
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget _rowHeader(BuildContext context, String heading, VoidCallback action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Heading(heading: heading),
        TextButtonWithIcon(
          onPressed: action,
          text: "More",
          icon: Icons.chevron_right_outlined,
        ),
      ],
    );
  }
}
