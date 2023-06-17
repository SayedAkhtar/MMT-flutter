import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/ShimmerLoader.dart';
import 'package:MyMedTrip/controller/controllers/hospital_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/models/hospital_model.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

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
  late HospitalController controller;
  late Hospital hospital;
  bool isLoading = true;
  late WebViewController iframeController;
  @override
  void initState() {
    controller = Get.put(HospitalController());
    fetchData();
    super.initState();
  }

  fetchData() async {
    Hospital? d = await controller.getHospitalById(arguments['id']);
    if (d != null) {
      setState(() {
        hospital = d;
        isLoading = false;
        iframeController = WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onProgress: (int progress) {
                // Update loading bar.
              },
              onPageStarted: (String url) {},
              onPageFinished: (String url) {},
              onWebResourceError: (WebResourceError error) {},
              onNavigationRequest: (NavigationRequest request) {
                return NavigationDecision.prevent;
                if (request.url.startsWith('https://www.youtube.com/')) {
                  return NavigationDecision.prevent;
                }
                return NavigationDecision.navigate;
              },
            ),
          )
          ..loadRequest(Uri.parse('https://goo.gl/maps/xstuDAWMd9a3K1UR8'));
        
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ShimmerLoader();
    }
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SizedBox(
            height: getVerticalSize(300),
            width: double.maxFinite,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(hospital.banners!.length, (index) {
                      return CustomImageView(
                          url: hospital.banners![index],
                          height: getVerticalSize(300),
                          width: getHorizontalSize(428),
                          alignment: Alignment.center);
                    })),
                // CustomImageView(
                //     imagePath: "Images/hos.png",
                //     height: getVerticalSize(300),
                //     width: getHorizontalSize(428),
                //     alignment: Alignment.center),
                Align(
                    child: CustomAppBarSecondary(
                  height: getVerticalSize(50),
                  leadingWidth: 52,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
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
                      Padding(
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
                                  Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: CustomImageView(
                                      url: hospital.doctors![i].image,
                                      height: getVerticalSize(100),
                                      width: getHorizontalSize(140),
                                      radius: BorderRadius.circular(
                                        getHorizontalSize(16),
                                      ),
                                      fit: BoxFit.cover,
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
                              onDoubleTap: (){
                                launchUrl(Uri.parse(hospital.mapFrame!));
                              },
                              child: Container(
                                  height: getVerticalSize(180),
                                  width: getHorizontalSize(380),
                                  margin: getMargin(top: 15, right: 15),
                                  child: CustomImageView(
                                    imagePath: 'assets/icons/map-placeholder.jpg',
                                  ),),
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

                      // Container(
                      //   width: getHorizontalSize(370),
                      //   margin: getMargin(top: 14, right: 33),
                      //   child: RichText(
                      //       maxLines: maxLines,
                      //       overflow: TextOverflow.ellipsis,
                      //       text: TextSpan(children: [
                      //         TextSpan(
                      //           text: "${hospital.description} ",
                      //           style: TextStyle(
                      //             color: Colors.black54,
                      //             fontSize: getFontSize(16),
                      //             fontFamily: 'Urbanist',
                      //             fontWeight: FontWeight.w400,
                      //             letterSpacing: getHorizontalSize(0.2),
                      //           ),
                      //         ),
                      //       ]),
                      //       textAlign: TextAlign.left),
                      // ),
                      // InkWell(
                      //     onTap: () {
                      //       if (maxLines == 3) {
                      //         setState(() {
                      //           maxLines = 1000;
                      //         });
                      //       } else {
                      //         setState(() {
                      //           maxLines = 3;
                      //         });
                      //       }
                      //     },
                      //     child: Text(
                      //       'Read More',
                      //       style: TextStyle(
                      //         color: MYcolors.cyan600,
                      //         fontSize: getFontSize(14),
                      //         fontFamily: 'Urbanist',
                      //         fontWeight: FontWeight.w400,
                      //         letterSpacing: getHorizontalSize(0.2),
                      //       ),
                      //     )),
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
                              itemCount: 3,
                              itemBuilder: (context, index) {
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
