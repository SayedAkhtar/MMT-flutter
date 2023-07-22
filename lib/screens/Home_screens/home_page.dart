import 'package:MyMedTrip/components/CustomImageView.dart';
import 'package:MyMedTrip/constants/home_model.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/models/faq_model.dart';
import 'package:MyMedTrip/providers/home_provider.dart';
import 'package:MyMedTrip/screens/Home_screens/widget/suggested_doctors.dart';
import 'package:MyMedTrip/screens/Home_screens/widget/suggested_hospitals.dart';
import 'package:MyMedTrip/screens/treatments/list.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/MarginBox.dart';
import 'package:MyMedTrip/constants/query_step_name.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/models/blog.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/screens/Home_screens/SearchScreen.dart';
import 'package:MyMedTrip/screens/Query/query_form.dart';
import 'package:MyMedTrip/screens/connects/support_connect.dart';
import 'package:MyMedTrip/screens/trending_blogs/read_blog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserController _userController;
  late DateTime currentBackPressTime;

  late HomeProvider homeProvider;

  List<Hospitals> hospitals = [];
  List<DoctorsHome> doctors = [];
  List<Faq> faqs = [];
  List<String> banners = [];
  List<Stories> stories = [];
  List blogs = [];
  bool isLoading = true;
  bool blogLoading = true;

  @override
  void initState() {
    super.initState();
    _userController = Get.find<UserController>();
    homeProvider = Get.put(HomeProvider());
    fetchHomeData();
    fetchBlogData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void fetchHomeData() async {
    Home? data = await homeProvider.getHomeData();
    if (data != null) {
      setState(() {
        hospitals = data.hospitals!;
        doctors = data.doctors!;
        faqs = data.faqs!;
        banners = data.banners!;
        stories = data.stories!;
        isLoading = false;
      });
    }
  }

  void fetchBlogData() async {
    List<Blog> blogData = await homeProvider.fetchBlogData();
    setState(() {
      blogs = blogData;
      blogLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          fetchHomeData();
          fetchBlogData();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: CustomSpacer.S,
                      left: CustomSpacer.S,
                      right: CustomSpacer.S),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        child: RichText(
                          maxLines: 3,
                          text: TextSpan(
                            text: "Welcome".tr,
                            style: AppStyle.txtUrbanistRegular10.copyWith(
                              fontSize: 32,
                              color: MYcolors.blackcolor,
                              // decoration: TextDecoration.underline
                            ),
                            children: [
                              const TextSpan(
                                text: ",\n",
                                style: TextStyle(height: 0),
                              ),
                              TextSpan(
                                text: "${_userController.user!.name}",
                                style: AppStyle.txtUrbanistRomanBold32.copyWith(
                                    fontSize: 42,
                                    color: MYcolors.blackcolor,
                                    decoration: TextDecoration.none),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => {Get.toNamed(Routes.setting)},
                        child: CircleAvatar(
                          backgroundImage: const AssetImage("Images/PR.png"),
                          foregroundImage: _userController.user!.image != null
                              ? NetworkImage(_userController.user!.image!)
                              : const AssetImage("Images/PR.png")
                                  as ImageProvider,
                        ),
                      ),
                    ],
                  ),
                ),
                MarginBox(
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const SearchScreen());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(CustomSpacer.S),
                      decoration: BoxDecoration(
                          color: MYcolors.whitecolor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 2,
                              spreadRadius: 0,
                              offset: const Offset(0, 1),
                            )
                          ]),
                      height: CustomSpacer.M * 2,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Search for doctors and hospitals'.tr),
                          CustomSpacer.s(),
                          const Icon(Icons.search_rounded),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: CustomSpacer.S,
                      left: CustomSpacer.S,
                      right: CustomSpacer.S,
                      bottom: CustomSpacer.M),
                  child: Wrap(
                    runSpacing: CustomSpacer.S,
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.startQuery);
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          height: getVerticalSize(200),
                          padding: getPadding(all: CustomSpacer.XS),
                          decoration: BoxDecoration(
                              color: const Color(0xFF98d7c8),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                )
                              ]),
                          child: Column(children: [
                            Text("Generate Query",
                                style: AppStyle.txtUrbanistRomanBold16.copyWith(
                                    fontSize: 16, color: MYcolors.whitecolor)),
                            Text("Click here to send your query",
                                style: AppStyle.txtUrbanistRegular14
                                    .copyWith(color: MYcolors.whitecolor),
                                textAlign: TextAlign.center),
                            const Spacer(),
                            CustomImageView(
                              imagePath: "assets/icons/generate-query.png",
                              height: getVerticalSize(102),
                            )
                          ]),
                        ),
                      ),
                      CustomSpacer.s(),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.teleconsultationSchedule);
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          height: getVerticalSize(200),
                          padding: getPadding(all: CustomSpacer.XS),
                          decoration: BoxDecoration(
                              color: const Color(0xFFff5b5a),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                )
                              ]),
                          child: Column(children: [
                            Text("Video Consultation".tr,
                                style: AppStyle.txtUrbanistRomanBold16.copyWith(
                                    fontSize: 16, color: MYcolors.whitecolor),
                                textAlign: TextAlign.center),
                            Text(
                              "Click here to speak with your doctor".tr,
                              style: AppStyle.txtUrbanistRegular14.copyWith(
                                color: MYcolors.whitecolor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            CustomImageView(
                              imagePath: "assets/icons/consultation.png",
                              height: getVerticalSize(102),
                            )
                          ]),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          Get.to(() => const TreatmentsList());
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          height: getVerticalSize(200),
                          padding: getPadding(all: CustomSpacer.XS),
                          decoration: BoxDecoration(
                              color: const Color(0xFF599749),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                )
                              ]),
                          child: Column(children: [
                            Text("Popular Treatments".tr,
                                style: AppStyle.txtUrbanistRomanBold16.copyWith(
                                    fontSize: 16, color: MYcolors.whitecolor),
                                textAlign: TextAlign.center),
                            Text("Click here to read about the treatments",
                                style: AppStyle.txtUrbanistRegular14
                                    .copyWith(color: MYcolors.whitecolor),
                                textAlign: TextAlign.center),
                            const Spacer(),
                            CustomImageView(
                              imagePath: "assets/icons/treatments.png",
                              height: getVerticalSize(98),
                            )
                          ]),
                        ),
                      ),
                      CustomSpacer.s(),
                      GestureDetector(
                        onTap: () {
                          QueryController _ctrl = Get.find<QueryController>();
                          _ctrl.queryType = 2;
                          _ctrl.currentStep.value = QueryStep.documentForVisa;
                          _ctrl.stepData = {};
                          Get.to(() => const QueryForm());
                        },
                        child: Container(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          height: getVerticalSize(200),
                          padding: getPadding(all: CustomSpacer.XS),
                          decoration: BoxDecoration(
                              color: const Color(0xFFdd6449),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  blurRadius: 2,
                                  spreadRadius: 0,
                                  offset: const Offset(0, 2),
                                )
                              ]),
                          child: Column(children: [
                            Text("Medical Visa".tr,
                                style: AppStyle.txtUrbanistRomanBold16.copyWith(
                                    fontSize: 16, color: MYcolors.whitecolor),
                                textAlign: TextAlign.center),
                            Text(
                              "Click here to apply for the medical visa".tr,
                              style: AppStyle.txtUrbanistRegular14.copyWith(
                                color: MYcolors.whitecolor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(),
                            CustomImageView(
                              imagePath: "assets/icons/visa.png",
                              height: getVerticalSize(112),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: banners.isNotEmpty,
                  child: SizedBox(
                    height: getVerticalSize(180),
                    child: PageView(children: [
                      for (var img in banners)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CustomImageView(
                            url: img,
                            width: MediaQuery.of(context).size.width,
                            fit: BoxFit.fill,
                            radius: BorderRadius.circular(8.0),
                          ),
                        )
                    ]),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: CustomSpacer.XS),
                  child: Wrap(
                    runSpacing: CustomSpacer.XS,
                    children: [
                      SuggestedHospitals(data: hospitals),
                      SuggestedDoctors(data: doctors),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const SupportConnect());
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
                            style: AppStyle.txtUrbanistRomanBold18,
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
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 2,
                                spreadRadius: 0,
                                offset: const Offset(0, 1),
                              )
                            ]),
                        height: 60,
                        child: Text(
                          "Wellness Centers".tr,
                          style: AppStyle.txtUrbanistRomanBold20
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      // _rowHeader(context, "Our latest blog", () {
                      //   _homeController.getBlogData();
                      // }),
                      Visibility(
                        visible: blogs.isNotEmpty,
                        child: SizedBox(
                          height: 380,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: blogs.length,
                              itemBuilder: (_, index) {
                                Blog currBlog = blogs[index];
                                RegExp exp = RegExp(r"<[^>]*>",
                                    multiLine: true, caseSensitive: true);
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(() => ReadBlogPage(currBlog.title!,
                                        currBlog.content!, currBlog.thumbnail!));
                                  },
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width - 40,
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
                                          Expanded(
                                            child: SizedBox(
                                              child: CustomImageView(
                                                url: currBlog.thumbnail!,
                                                fit: BoxFit.fill,
                                                height: getVerticalSize(150),
                                              ),
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                      boxShadow: [
                                                        BoxShadow(
                                                          color: Colors.grey
                                                              .withOpacity(0.5),
                                                          blurRadius: 2,
                                                          spreadRadius: 0,
                                                          offset:
                                                              const Offset(0, 1),
                                                        )
                                                      ]),
                                                  alignment: Alignment.center,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        "${currBlog.getFormattedDate().day}",
                                                        style: AppStyle
                                                            .txtUrbanistRomanBold32
                                                            .copyWith(
                                                                color:
                                                                    Colors.white),
                                                      ),
                                                      Text(
                                                        Utils.getMonthShortName(
                                                            currBlog
                                                                .getFormattedDate()
                                                                .month),
                                                        style: AppStyle
                                                            .txtUrbanistRomanBold20
                                                            .copyWith(
                                                                color:
                                                                    Colors.white),
                                                      ),
                                                    ],
                                                  )),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "${currBlog.title}",
                                                      maxLines: 3,
                                                      style: AppStyle
                                                          .txtUrbanistRomanBold20
                                                          .copyWith(
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis),
                                                    ),
                                                    Container(
                                                      alignment: Alignment.center,
                                                      child: Text(
                                                        "${currBlog.excerpt?.replaceAll(exp, '')}",
                                                        maxLines: 3,
                                                        style: AppStyle
                                                            .txtUrbanistRegular18
                                                            .copyWith(
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
                                            child: TextButton(
                                              onPressed: () {
                                                Get.to(() => ReadBlogPage(
                                                    currBlog.title!,
                                                    currBlog.content!,
                                                    currBlog.thumbnail!));
                                              },
                                              child: Text(
                                                'Explore'.tr,
                                                style: AppStyle
                                                    .txtUrbanistRomanBold18Cyan60001,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                      Text(
                        "Not convinced ?\nCheck out some of our Patient's stories."
                            .tr,
                        style: AppStyle.txtUrbanistRomanBold24,
                      ),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          runSpacing: 8.0,
                          spacing: 8.0,
                          children: List.generate(stories.length, (index) {
                            return Container(
                              // color: MYcolors.greencolor,
                              height: MediaQuery.of(context).size.height * 0.10,
                              width: MediaQuery.of(context).size.width * 0.22,
                              child: CustomImageView(
                                url: stories[index].value,
                                fit: BoxFit.fill,
                              ),
                            );
                          }),
                        ),
                      ),

                      Visibility(
                        visible: faqs.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomSpacer.s(),
                            Text(
                              "Frequently Asked Questions ".tr,
                              style: AppStyle.txtUrbanistRomanBold24,
                            ),
                            ...List<Widget>.generate(faqs.length, (int index) {
                              return ExpansionTile(
                                tilePadding: const EdgeInsets.all(0),
                                title: Text(
                                  faqs[index].question!,
                                  style: AppStyle.txtUrbanistRomanBold18,
                                ),
                                children: [
                                  Text(
                                    faqs[index].answer!,
                                    style: AppStyle.txtUrbanistRegular18,
                                  ),
                                ],
                              );
                            })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CustomSpacer.m()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
