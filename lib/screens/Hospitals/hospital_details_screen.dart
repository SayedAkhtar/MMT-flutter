import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/ShimmerLoader.dart';
import 'package:MyMedTrip/controller/controllers/hospital_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/models/hospital_model.dart';
import 'package:MyMedTrip/providers/hospital_provider.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/CustomImageView.dart';
import '../../constants/size_utils.dart';
import '../../theme/app_style.dart';
import 'package:flutter/material.dart';

// ignore_for_file: must_be_immutable
class HospitalDetailsScreen extends StatefulWidget {
  const HospitalDetailsScreen({super.key});
  @override
  State<HospitalDetailsScreen> createState() => _HospitalDetailsScreenState();
}

class _HospitalDetailsScreenState extends State<HospitalDetailsScreen> {
  dynamic arguments = Get.arguments;
  int maxLines = 3;
  late HospitalProvider _provider;
  late Hospital hospital;
  bool isLoading = true;
  @override
  void initState() {
    _provider = Get.put(HospitalProvider());
    fetchData();
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  fetchData() async {
    Hospital? d = await _provider.getHospitalById(arguments['id']);
    if (d != null) {
      setState(() {
        hospital = d;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ShimmerLoader();
    }
    print(hospital.banners!.isEmpty);
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            height: getVerticalSize(300),
            width: double.maxFinite,
            color: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(hospital.banners!.length, (index) {
                      return CustomImageView(
                          url: hospital.banners![index],
                          // height: getVerticalSize(300),
                          width: MediaQuery.of(context).size.width,
                          fit: BoxFit.fitHeight,
                          alignment: Alignment.center
                      );
                    })),
                Align(
                    child: CustomAppBarSecondary(
                  height: getVerticalSize(50),
                  leadingWidth: 52,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.grey,),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ))
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: getPadding(left: 24, top: 25, bottom: 78),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("${hospital.name}",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          style: AppStyle.txtUrbanistRomanBold32
                              .copyWith(color: Colors.black87)),
                      Padding(
                          padding: getPadding(top: 14, right: CustomSpacer.M),
                          child: Row(children: [
                            CustomImageView(
                                imagePath: "assets/icons/location-sm.png",
                                height: getSize(20),
                                width: getSize(20)),
                            Expanded(
                              child: Padding(
                                padding: getPadding(left: 8, top: 1, bottom: 1),
                                child: Text(
                                  "${hospital.address} ",
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtUrbanistRegular18.copyWith(
                                    color: Colors.black54,
                                    letterSpacing: getHorizontalSize(0.2),
                                  ),
                                ),
                              ),
                            )
                          ])),
                      Visibility(
                        visible: hospital.doctors!.isEmpty,
                        child: Padding(
                          padding: getPadding(top: 41, right: CustomSpacer.S),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Doctors",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtUrbanistRomanBold20),
                              GestureDetector(
                                onTap: () {},
                                child: Padding(
                                  padding: getPadding(bottom: 4),
                                  child: Text(
                                    "See All",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtUrbanistRomanBold16Blue
                                        .copyWith(
                                      letterSpacing: getHorizontalSize(0.2),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),

                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: getPadding(top: 14),
                        child: IntrinsicWidth(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                for (var i = 0;
                                    i < hospital.doctors!.length;
                                    i++)
                                  GestureDetector(
                                    onTap: () => {
                                      Get.toNamed(Routes.doctorPreviewNew,
                                          arguments: {
                                            'id': hospital.doctors![i].id
                                          })
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 16),
                                      child: Stack(children: [
                                        CustomImageView(
                                          url: hospital.doctors![i].image,
                                          height: getVerticalSize(100),
                                          width: getHorizontalSize(140),
                                          radius: BorderRadius.circular(
                                            getHorizontalSize(16),
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          height: getVerticalSize(100),
                                          width: getHorizontalSize(140),
                                          decoration: BoxDecoration(
                                            color: Colors.black45.withAlpha(90),
                                            borderRadius: BorderRadius.circular(
                                              getHorizontalSize(16),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                hospital.doctors![i].name!,
                                                style:
                                                    AppStyle.txtUrbanistRegular14,
                                              ),
                                              Text(
                                                hospital.doctors![i].specialization!.join(", "),
                                                style:
                                                    AppStyle.txtUrbanistRegular14,
                                                    textAlign: TextAlign.center,
                                              ),
                                            ],
                                          ),
                                        )
                                      ]),
                                    ),
                                  )
                              ]),
                        ),
                      ),
                      Padding(
                          padding: getPadding(top: 29),
                          child: Text("Details",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtUrbanistRomanBold20)),
                      Padding(
                        padding: getPadding(
                            left: CustomSpacer.S,
                            top: CustomSpacer.S,
                            right: CustomSpacer.S),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomImageView(
                                          imagePath: "assets/icons/blog-sm.png",
                                          height: getSize(32),
                                          width: getSize(32)),
                                      Padding(
                                        padding: getPadding(top: 7),
                                        child: Text(
                                          "${hospital.blogs?.length}\nBlogs",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: AppStyle
                                              .txtUrbanistRomanMedium18
                                              .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2),
                                          ),
                                        ),
                                      ),
                                    ]),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomImageView(
                                          imagePath:
                                              "assets/icons/doctor-sm.png",
                                          height: getSize(32),
                                          width: getSize(32)),
                                      Padding(
                                        padding: getPadding(top: 7),
                                        child: Text(
                                          "${hospital.doctors!.length}\nDoctors",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: AppStyle
                                              .txtUrbanistRomanMedium18
                                              .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2),
                                          ),
                                        ),
                                      ),
                                    ]),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomImageView(
                                          imagePath:
                                              "assets/icons/treatment-sm.png",
                                          height: getSize(32),
                                          width: getSize(32)),
                                      Padding(
                                        padding: getPadding(top: 7),
                                        child: Text(
                                          "${hospital.treatment?.length}\nTreatments",
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.center,
                                          style: AppStyle
                                              .txtUrbanistRomanMedium18
                                              .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2),
                                          ),
                                        ),
                                      )
                                    ]),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      CustomImageView(
                                          imagePath:
                                              "assets/icons/accreditation-sm.png",
                                          height: getSize(32),
                                          width: getSize(32),
                                          onTap: () {}),
                                      Padding(
                                        padding: getPadding(top: 8),
                                        child: Text(
                                          "40\nSpecializations",
                                          overflow: TextOverflow.clip,
                                          textAlign: TextAlign.center,
                                          style: AppStyle
                                              .txtUrbanistRomanMedium18
                                              .copyWith(
                                            letterSpacing:
                                                getHorizontalSize(0.2),
                                          ),
                                        ),
                                      ),
                                    ]),
                              ]),
                        ),
                      ),
                      Visibility(
                        visible: hospital.mapFrame != null,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                                padding: getPadding(top: CustomSpacer.S),
                                child: Text("Location",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtUrbanistRomanBold20)),
                            GestureDetector(
                              onDoubleTap: () {
                                launchUrl(Uri.parse(hospital.mapFrame!));
                              },
                              child: Container(
                                height: getVerticalSize(180),
                                width: getHorizontalSize(380),
                                margin: getMargin(top: 15, right: 15),
                                child: CustomImageView(
                                  imagePath: 'assets/icons/map-placeholder.jpg',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                          visible: hospital.description != null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                  padding: getPadding(top: 31),
                                  child: Text("Description",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtUrbanistRomanBold20)),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 500),
                                width: getHorizontalSize(370),
                                // margin: getMargin(top: 14, right: 33),
                                child: Html(
                                  data: hospital.description,
                                ),
                              ),
                            ],
                          )),
                      Visibility(

                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: getPadding(top: 30, right: 24),
                            child: Row(children: [
                              Text("Patient Testimonials",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtUrbanistRomanBold20),
                              const Spacer(),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.patientTestimony);
                                },
                                child: Padding(
                                  padding: getPadding(top: 1, bottom: 2),
                                  child: Text(
                                    "See All",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtUrbanistRomanBold16Blue
                                        .copyWith(
                                      letterSpacing: getHorizontalSize(0.2),
                                    ),
                                  ),
                                ),
                              ),
                            ]),
                          ),
                          Padding(
                            padding:
                                getPadding(top: CustomSpacer.XS, right: 24),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: CustomSpacer.S,
                                mainAxisSpacing: CustomSpacer.S,
                              ),
                              itemCount: hospital.testimony!.length,
                              itemBuilder: (context, index) {
                                if(hospital.testimony![index].type == "image"){
                                  return CustomImageView(
                                    imagePath: "Images/P1.jpg",
                                    height: getSize(
                                      MediaQuery.of(context).size.width * 0.35,
                                    ),
                                    width: getSize(
                                      MediaQuery.of(context).size.width * 0.35,
                                    ),
                                    radius: BorderRadius.circular(
                                      getHorizontalSize(
                                        16,
                                      ),
                                    ),
                                  );
                                }

                              },
                            ),
                          ),
                        ],
                      )),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
