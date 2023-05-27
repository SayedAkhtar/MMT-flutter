import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomCardWithImage.dart';
import 'package:mmt_/components/HorizontalShimmer.dart';
import 'package:mmt_/components/MarginBox.dart';
import 'package:mmt_/components/TextButtonWithIcon.dart';
import 'package:mmt_/constants/query_step_name.dart';
import 'package:mmt_/controller/controllers/doctor_controller.dart';
import 'package:mmt_/controller/controllers/home_controller.dart';
import 'package:mmt_/controller/controllers/hospital_controller.dart';
import 'package:mmt_/controller/controllers/query_controller.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/helper/Utils.dart';
import 'package:mmt_/models/blog.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/constants/colors.dart';
import 'package:mmt_/screens/Home_screens/SearchScreen.dart';
import 'package:mmt_/screens/Query/query_form.dart';
import 'package:mmt_/screens/Video_consult/doctor_call.dart';
import 'package:mmt_/screens/connects/support_connect.dart';
import 'package:mmt_/screens/trending_blogs/read_blog.dart';
import 'package:shimmer/shimmer.dart';

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
    return Scaffold(
      backgroundColor: Color(0xffedf2f4),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Color(0xff343a40),
        leading: SizedBox(
          height: 100,
          child: TextButton(
            onPressed: () {
              Get.toNamed(Routes.setting);
            },
            child: CircleAvatar(
              backgroundImage: const AssetImage("Images/PR.png"),
              foregroundImage: NetworkImage(_userController.user!.image!),
            ),

          ),
        ),
        centerTitle: false,
        title: Text(
          "Hi, ${_userController.user != null ? _userController.user!.name : 'Name'}",
          style: const TextStyle(
              fontFamily: "BrandonMed",
              fontSize: 20,
              color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: 32,
                color: Colors.white70,
              ))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _homeController.isLoading.value = true;
          _homeController.getHomeData();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              Obx(() {
                if (!_homeController.isLoading.value) {
                  if (_homeController.banners.isEmpty) {
                    return SizedBox();
                  }
                  return SizedBox(
                    height: 150,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _homeController.banners.length,
                        itemBuilder: (_, index) {
                          return Container(
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(),
                            child: Image.network(
                              _homeController.banners[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                  );
                }
                return SizedBox();
              }),
              //----- Search Bar
              MarginBox(
                child: InkWell(
                  onTap: () {
                    Get.to(() => const SearchScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.all(CustomSpacer.S),
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
                        const Icon(Icons.search_rounded),
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
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 2,
                          spreadRadius: 0,
                          offset: const Offset(0, 1),
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
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset(
                                "assets/icons/generate-query.svg"),
                            Text(
                              "Generate \nQuery".tr,
                              style: const TextStyle(color: Colors.black),
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
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset("assets/icons/video.svg"),
                            Text(
                              "Video \nConsultation".tr,
                              style: const TextStyle( color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          QueryController _ctrl = Get.find<QueryController>();
                          _ctrl.queryType = 2;
                          _ctrl.currentStep.value = QueryStep.documentForVisa;
                          _ctrl.stepData = {};
                          Get.to(() => const QueryForm());
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        child: Column(
                          children: [
                            SvgPicture.asset("assets/icons/medical-visa.svg"),
                            Text(
                              "Medical \nvisa".tr,
                              style: const TextStyle( color: Colors.black),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: CustomSpacer.XS),
                child: Wrap(
                  runSpacing: CustomSpacer.XS,
                  children: [
                    _rowHeader(context, "Suggested Hospitals", () {
                      Get.toNamed(Routes.hospitals,
                          arguments: {'type': 'allHospitals'});
                    }),
                    SizedBox(
                      height: 240,
                      child: GetBuilder<HomeController>(
                          builder: (_ctrl){
                            if(_homeController.isLoading.isFalse){
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _homeController.hospitals.length,
                                  itemBuilder: (_, index) {
                                    return CustomCardWithImage(
                                      onTap: () {
                                        _hospitalController.openHospitalDetails(
                                            _homeController.hospitals[index].id!);
                                      },
                                      imageUri:
                                      _homeController.hospitals[index].logo,
                                      title:
                                      _homeController.hospitals[index].name,
                                      bodyText: _homeController
                                          .hospitals[index].address,
                                      icon: Icons.pin_drop,
                                    );
                                  });
                            }
                            if (_homeController.isLoading.isTrue) {
                              return const HorizontalShimmer();
                            }
                            return const Center(
                              child: Text("No Hospitals Found"),
                            );
                          }
                      ),
                    ),
                    _rowHeader(context, "Suggested Doctors", () {
                      Get.toNamed(Routes.doctors,
                          arguments: {'type': 'allDoctor'});
                    }),
                    SizedBox(
                      height: 240,
                      child: GetBuilder<HomeController>(
                          builder: (_ctrl){
                            if(_homeController.isLoading.isFalse){
                              return ListView.builder(
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
                              });
                            }
                            if (_homeController.isLoading.isTrue) {
                              return const HorizontalShimmer();
                            }
                            return const Center(
                              child: Text("No Doctors Found"),
                            );
                          }
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(SupportConnect());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: CustomSpacer.S),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: MYcolors.whitecolor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: MYcolors.blackcolor),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 2,
                                spreadRadius: 0,
                                offset: const Offset(0, 1),
                              )
                            ]),
                        height: 70,
                        child: Text(
                          "Need help from where to start? talk us.".tr,
                          style: const TextStyle(
                            fontFamily: "Brandon",
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(
                          horizontal: CustomSpacer.XS),
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
                        "Wellness Centers".tr,
                        style: const TextStyle(
                            fontFamily: "Brandon",
                            fontSize: 20,
                            color: MYcolors.whitecolor),
                      ),
                    ),
                    _rowHeader(context, "Our latest blog", () {
                      _homeController.getBlogData();
                    }),
                    Obx(() {
                      if (_homeController.isLoading.isFalse) {
                        return SizedBox(
                          height: 430,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _homeController.blogs.length,
                              itemBuilder: (_, index) {
                                Blog currBlog = _homeController.blogs[index];
                                RegExp exp = RegExp(r"<[^>]*>",
                                    multiLine: true, caseSensitive: true);
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => ReadBlogPage(
                                        currBlog.title!,
                                        currBlog.content!,
                                        currBlog.thumbnail!));
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width -
                                        40,
                                    child: Card(
                                      clipBehavior: Clip.hardEdge,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          SizedBox(
                                            height: 230,
                                            child: Image.network(
                                              currBlog.thumbnail!,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets
                                                          .only(
                                                      right: CustomSpacer.XS,
                                                      left: CustomSpacer.XS),
                                                  decoration: BoxDecoration(
                                                      color:
                                                          MYcolors.bluecolor,
                                                      borderRadius:
                                                          BorderRadius
                                                              .circular(10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.5),
                                                          blurRadius: 2,
                                                          spreadRadius: 0,
                                                          offset:
                                                              Offset(0, 1),
                                                        )
                                                      ]),
                                                  alignment: Alignment.center,
                                                  width:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.20,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                        "${currBlog.getFormattedDate().day}",
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                "BrandonMed",
                                                            fontSize: 19,
                                                            color: MYcolors
                                                                .whitecolor),
                                                      ),
                                                      Text(
                                                        Utils.getMonthShortName(
                                                            currBlog
                                                                .getFormattedDate()
                                                                .month),
                                                        style: const TextStyle(
                                                            fontFamily:
                                                                "BrandonMed",
                                                            fontSize: 19,
                                                            color: MYcolors
                                                                .whitecolor),
                                                      ),
                                                    ],
                                                  )),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .start,
                                                  children: [
                                                    Text(
                                                      "${currBlog.title}",
                                                      maxLines: 3,
                                                      style: const TextStyle(
                                                          fontFamily:
                                                              "Brandon",
                                                          fontSize: 19,
                                                          color: MYcolors
                                                              .blackcolor,
                                                          overflow:
                                                              TextOverflow
                                                                  .ellipsis),
                                                    ),
                                                    Container(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "${currBlog.excerpt?.replaceAll(exp, '')}",
                                                        maxLines: 3,
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                            fontFamily:
                                                                "BrandonReg",
                                                            fontSize: 14,
                                                            color: MYcolors
                                                                .blackcolor,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            margin: const EdgeInsets.only(
                                                right: CustomSpacer.XS),
                                            child: OutlinedButton(
                                              onPressed: () {
                                                Get.to(() => ReadBlogPage(
                                                    currBlog.title!,
                                                    currBlog.content!,
                                                    currBlog.thumbnail!));
                                              },
                                              style: OutlinedButton.styleFrom(
                                                foregroundColor:
                                                    MYcolors.blacklightcolors,
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            100)),
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
                      } else {
                        print("false");
                      }
                      return Text("");
                    }),
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
                    const Heading(heading: "FAQs"),
                    Obx(() {
                      if (_homeController.isLoading.isFalse) {
                        List<Widget> f = [];
                        _homeController.faqs!.forEach((element) {
                          f.add(InkWell(
                            onTap: (){
                              Get.defaultDialog(title: element.question!,
                                  content:Text(element.answer!)
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.all(CustomSpacer.XS),
                              decoration: BoxDecoration(
                                  color: MYcolors.whitecolor,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: MYcolors.blacklightcolors, width: 0.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      blurRadius: 2,
                                      spreadRadius: 0,
                                      offset: const Offset(0, 1),
                                    )
                                  ]),
                              child: Text(
                                "${element.question}",
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                                ),
                                maxLines: 2,
                              ),
                            ),
                          ));
                        });
                        return Wrap(
                          runSpacing: CustomSpacer.XS,
                          children: f,
                        );
                      }
                      return const Center(
                        child: Text("No FAQs Found"),
                      );
                    }),
                  ],
                ),
              ),

              SizedBox(
                height: MediaQuery.of(context).size.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _rowHeader(BuildContext context, String heading, VoidCallback action,
      {String? text}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Heading(heading: heading),
        TextButtonWithIcon(
          onPressed: action,
          text: text ?? "More",
          icon: Icons.chevron_right_outlined,
        ),
      ],
    );
  }
}
