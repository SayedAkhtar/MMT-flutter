import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/CustomImageView.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class DoctorDetailScreen extends StatelessWidget {
  const DoctorDetailScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarSecondary(
        leading: IconButton(
          onPressed: () {
            Get.offAllNamed(Routes.home);
          },
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
        ),
        leadingWidth: 64,
        height: getVerticalSize(kToolbarHeight),
        title: Text("Doctor Details", style: AppStyle.txtUrbanistRomanBold20),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(CustomSpacer.S),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(children: [
                  CustomImageView(
                    url:
                        "https://mymedtrip.com/wp-content/uploads/2023/03/Dr-Rahul-Bhargava.jpg",
                    height: getSize(150),
                    width: getSize(180),
                    fit: BoxFit.fill,
                    radius: BorderRadius.circular(getHorizontalSize(8)),
                  ),
                  Padding(
                    padding: getPadding(left: CustomSpacer.S),
                    child: Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: getSize(210),
                            child: Flexible(
                              child: Text("Dr. Rahul Bhargava",
                                  overflow: TextOverflow.clip,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtUrbanistRomanBold24),
                            ),
                          ),
                          Container(
                            padding: getPadding(top: 9),
                            width: getSize(210),
                            child: Flexible(
                              child: Text(
                                  "Director & HOD MBBS, MD (Medicine), DM (Clinical Haematology)",
                                  maxLines: 3,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtUrbanistRegular18),
                            ),
                          ),
                          Padding(
                            padding: getPadding(top: 7),
                            child: Row(children: [
                              CustomImageView(
                                  imagePath: "assets/icons/experience-sm.png",
                                  height: getSize(26),
                                  margin: getMargin(bottom: 1)),
                              Container(
                                width: getSize(180),
                                padding: getPadding(left: 4, top: 3),
                                child: Text("4.7",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtUrbanistRegular14
                                        .copyWith(color: Colors.black87)),
                              ),
                            ]),
                          ),
                          Padding(
                            padding: getPadding(top: 7),
                            child: Row(children: [
                              CustomImageView(
                                  imagePath: "assets/icons/location-sm.png",
                                  height: getSize(26),
                                  margin: getMargin(bottom: 1)),
                              Container(
                                  padding: getPadding(left: 4),
                                  width: getSize(180),
                                  child: Text("800m away",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtUrbanistRegular14
                                          .copyWith(color: Colors.black87)))
                            ]),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                Padding(
                  padding: getPadding(top: 17),
                  child: Text("About The Doctor",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtUrbanistRomanBold20),
                ),
                Container(
                  width: getHorizontalSize(305),
                  margin: getMargin(top: 12, right: 21),
                  child: RichText(
                      text: TextSpan(children: [
                        TextSpan(
                            text:
                                "Dr Rahul Bhargava has completed over 800 transplants till date. Dr Bhargava has been credited of establishing 10 low cost centres across India namely at Sarvodaya hospital, Batra hospital, Action Balaji hospital etc. With a vision of anaemia free and thalassemia free India, Dr Rahul Bhargava actively collaborates with various government initiatives in order to provide low cost BMT treatment to the masses. ",
                            style: TextStyle(
                                color: MYcolors.gray90001,
                                fontSize: getFontSize(18),
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400)),
                        TextSpan(
                            text: "Read more",
                            style: TextStyle(
                                color: MYcolors.bluecolor,
                                fontSize: getFontSize(12),
                                fontFamily: 'Urbanist',
                                fontWeight: FontWeight.w500))
                      ]),
                      textAlign: TextAlign.left),
                ),
                Visibility(
                    visible: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: getPadding(top: 17),
                          child: Text("Specialization",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtUrbanistRomanBold20),
                        ),
                        Column(
                          children: List<Widget>.generate(2, (index) {
                            return Padding(
                              padding: getPadding(
                                  top: CustomSpacer.XS, left: CustomSpacer.XS),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8.0,
                                children: [
                                  Icon(Icons.circle,
                                      size: 8, color: MYcolors.cyan60001),
                                  Text("Haematology",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtUrbanistRegular18),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    )),
                Visibility(
                    visible: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: getPadding(top: 17),
                          child: Text("Awards",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtUrbanistRomanBold20),
                        ),
                        Column(
                          children: List<Widget>.generate(2, (index) {
                            return Padding(
                              padding: getPadding(
                                  top: CustomSpacer.XS, left: CustomSpacer.XS),
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                spacing: 8.0,
                                children: [
                                  Icon(Icons.circle,
                                      size: 8, color: MYcolors.cyan60001),
                                  Text("Best outgoing student in MD bhopal",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtUrbanistRegular18),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    )),
                Visibility(
                  visible: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                          padding: getPadding(top: 17),
                          child: Text("Consultation timings",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtUrbanistRomanBold20),
                        ),
                      Padding(
                  padding: getPadding(top: 32),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal, 
                    child: Row(
                      children: List<Widget>.generate(7, (index) {
                        return Container(
                          margin: getMargin(right: CustomSpacer.XS),
                          padding: getPadding(
                              left: 12, top: 13, right: 12, bottom: 13),
                          decoration: BoxDecoration(
                              color: MYcolors.gray200,
                              borderRadius: BorderRadius.circular(8)),
                          child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: getPadding(top: 1),
                                  child: Text("${ DateFormat('MMMM d').format(DateTime.now().add(Duration(days: index)))}",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtUrbanistRegular10.copyWith(color: MYcolors.bluecolor)),
                                ),
                                Padding(
                                  padding: getPadding(left: 1, top: 2),
                                  child: Text("${ DateFormat('EEEE').format(DateTime.now().add(Duration(days: index)))}",
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      style: AppStyle.txtUrbanistRomanBold18),
                                )
                              ]),
                        );
                      }),
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(top: 32, bottom: 5),
                  child: Wrap(
                    runSpacing: getVerticalSize(5),
                    spacing: getHorizontalSize(5),
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: List<Widget>.generate(9, (index) => timeChip()),
                  ),
                ),
                    ],
                  ),
                ),
                
              ]),
        ),
      ),
    );
  }

  onTapBookapointmentOne(BuildContext context) {}

  onTapArrowleft4(BuildContext context) {
    Navigator.pop(context);
  }

  Widget timeChip() {
    return RawChip(
      padding: getPadding(
        left: 25,
        right: 25,
      ),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        "09:00 AM",
        textAlign: TextAlign.left,
        style: TextStyle(
          color: MYcolors.gray400,
          fontSize: getFontSize(
            12,
          ),
          fontFamily: 'Raleway',
          fontWeight: FontWeight.w400,
        ),
      ),
      selected: false,
      backgroundColor: MYcolors.whiteA700,
      selectedColor: MYcolors.whiteA700,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: MYcolors.blueGray900,
          width: getHorizontalSize(
            1,
          ),
        ),
        borderRadius: BorderRadius.circular(
          getHorizontalSize(
            15,
          ),
        ),
      ),
      onSelected: (value) {},
    );
  }
}
