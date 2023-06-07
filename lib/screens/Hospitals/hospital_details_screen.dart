import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/CustomImageView.dart';
import '../../constants/colors.dart';
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
  int maxLines = 3;
  @override
  Widget build(BuildContext context) {
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
                CustomImageView(
                    imagePath: "Images/hos.png",
                    height: getVerticalSize(300),
                    width: getHorizontalSize(428),
                    alignment: Alignment.center),
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
                      Text("Royale President Hotel",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtUrbanistRomanBold32
                              .copyWith(color: Colors.black87)),
                      Padding(
                          padding: getPadding(top: 14, right: CustomSpacer.M),
                          child: Row(children: [
                            CustomImageView(
                                imagePath: "assets/icons/location-sm.png",
                                height: getSize(20),
                                width: getSize(20)),
                            Padding(
                              padding: getPadding(left: 8, top: 1, bottom: 1),
                              child: Text(
                                "79 Place de la Madeleine, Paris, 75009, France ",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtUrbanistRegular18.copyWith(
                                  color: Colors.black54,
                                  letterSpacing: getHorizontalSize(0.2),
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
                                for (var i = 0; i < 10; i++)
                                  Container(
                                    margin: const EdgeInsets.only(right: 16),
                                    child: CustomImageView(
                                      imagePath: "Images/men.jpg",
                                      height: getVerticalSize(100),
                                      width: getHorizontalSize(140),
                                      radius: BorderRadius.circular(
                                        getHorizontalSize(16),
                                      ),
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
                                          "0\nBlogs",
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
                                          "4\nDoctors",
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
                                          "2\nTreatments",
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
                      Padding(
                          padding: getPadding(top: 31),
                          child: Text("Description",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtUrbanistRomanBold20)),
                      Container(
                        width: getHorizontalSize(370),
                        margin: getMargin(top: 14, right: 33),
                        child: RichText(
                            maxLines: maxLines,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(children: [
                              TextSpan(
                                text:
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in cillum pariatur. ",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: getFontSize(16),
                                  fontFamily: 'Urbanist',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: getHorizontalSize(0.2),
                                ),
                              ),
                            ]),
                            textAlign: TextAlign.left),
                      ),
                      InkWell(
                          onTap: () {
                            if (maxLines == 3) {
                              setState(() {
                                maxLines = 1000;
                              });
                            } else {
                              setState(() {
                                maxLines = 3;
                              });
                            }
                          },
                          child: Text(
                            'Read More',
                            style: TextStyle(
                              color: MYcolors.cyan600,
                              fontSize: getFontSize(14),
                              fontFamily: 'Urbanist',
                              fontWeight: FontWeight.w400,
                              letterSpacing: getHorizontalSize(0.2),
                            ),
                          )),
                      Padding(
                          padding: getPadding(top: 28),
                          child: Text("Location",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtUrbanistRomanBold20)),
                      Container(
                          height: getVerticalSize(180),
                          width: getHorizontalSize(380),
                          margin: getMargin(top: 15),
                          child: Stack(children: [
                            Html(
                              data:
                                  '''<iframe src="https://www.google.com/" allowfullscreen></iframe>''',
                            ),
                          ])),
                      Padding(
                        padding: getPadding(top: 30, right: 24),
                        child: Row(children: [
                          Text("Patient Testimonials",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtUrbanistRomanBold20),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {},
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
                        padding: getPadding(top: CustomSpacer.XS, right: 24),
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
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
