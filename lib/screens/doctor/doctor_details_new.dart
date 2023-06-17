import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/components/CustomImageView.dart';
import 'package:MyMedTrip/components/CheckDisplay.dart';
import 'package:MyMedTrip/components/ShimmerLoader.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/controller/controllers/doctor_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/models/doctor.dart';
import 'package:MyMedTrip/providers/doctor_provider.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({Key? key}) : super(key: key);

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  dynamic data = Get.arguments;
  late DoctorProvider api;
  Doctor? doctor;
  bool isLoading = true;

  @override
  void initState() {
    api = Get.put(DoctorProvider());
    fetchData();
    super.initState();
  }

  fetchData() async {
    Doctor? d = await api.getDoctorById(data['id']); 
    setState(() {
      doctor = d;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const ShimmerLoader();
    }
    if (doctor == null) {
      return const Center(child: Text("No Data Found"));
    }
    return Scaffold(
      appBar: CustomAppBarSecondary(
        leading: IconButton(
          onPressed: () {
            Get.back();
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
                    url: doctor!.image,
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
                              child: Text(doctor!.name!,
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
                              child: Text(doctor!.designation!.join(", "),
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
                                child: Text("${doctor!.experience!} years",
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.left,
                                    style: AppStyle.txtUrbanistRegular14
                                        .copyWith(color: Colors.black87)),
                              ),
                            ]),
                          ),
                          doctor!.hospitals!.isNotEmpty?
                          CheckDisplay(
                            display: doctor!.hospitals!.isNotEmpty,
                            child: Padding(
                              padding: getPadding(top: 7),
                              child: Row(children: [
                                CustomImageView(
                                    imagePath: "assets/icons/location-sm.png",
                                    height: getSize(26),
                                    margin: getMargin(bottom: 1)),
                                Container(
                                    padding: getPadding(left: 4),
                                    width: getSize(180),
                                    child: Text(
                                        "${doctor!.hospitals!.first.name}",
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.left,
                                        style: AppStyle.txtUrbanistRegular14
                                            .copyWith(color: Colors.black87)))
                              ]),
                            ),
                          ):SizedBox(),
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
                            text: Utils.stripHtmlIfNeeded(doctor!.description!),
                            style: TextStyle(
                                color: MYcolors.gray90001,
                                fontSize: getFontSize(18),
                                fontFamily: 'Raleway',
                                fontWeight: FontWeight.w400)),
                        // TextSpan(
                        //     text: "Read more",
                        //     style: TextStyle(
                        //         color: MYcolors.bluecolor,
                        //         fontSize: getFontSize(12),
                        //         fontFamily: 'Urbanist',
                        //         fontWeight: FontWeight.w500))
                      ]),
                      textAlign: TextAlign.left),
                ),
                Visibility(
                    visible: doctor!.specialization!.isNotEmpty,
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
                          children: List<Widget>.generate(
                              doctor!.specialization!.length, (index) {
                            return Padding(
                              padding: getPadding(
                                  top: CustomSpacer.XS, left: CustomSpacer.XS),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.circle,
                                      size: 8, color: MYcolors.cyan60001),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(child: Text(doctor!.specialization![index],
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.left,
                                      maxLines: 3,
                                      style: AppStyle.txtUrbanistRegular18)),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    )),
                Visibility(
                    visible: doctor!.awards!.isNotEmpty,
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
                          children: List<Widget>.generate(
                              doctor!.awards!.length, (index) {
                            return Padding(
                              padding: getPadding(
                                  top: CustomSpacer.XS, left: CustomSpacer.XS),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.circle,
                                      size: 8, color: MYcolors.cyan60001),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                      child: Text(doctor!.awards![index],
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          textAlign: TextAlign.left,
                                          style:
                                              AppStyle.txtUrbanistRegular18)),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    )),
                    Visibility(
                    visible: doctor!.hospitals!.isNotEmpty,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: getPadding(top: 17),
                          child: Text("Hospitals",
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.left,
                              style: AppStyle.txtUrbanistRomanBold20),
                        ),
                        Column(
                          children: List<Widget>.generate(
                              doctor!.hospitals!.length, (index) {
                            return Padding(
                              padding: getPadding(
                                  top: CustomSpacer.XS, left: CustomSpacer.XS),
                              child: GestureDetector(
                                onTap: (){
                                  Get.toNamed(Routes.hospitalPreview,arguments: {'id':doctor!.hospitals![index].id});
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.circle,
                                        size: 8, color: MYcolors.cyan60001),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Flexible(
                                        child: Text(doctor!.hospitals![index].name!,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.left,
                                            style:
                                                AppStyle.txtUrbanistRegular18)),
                                                const SizedBox(
                                      width: 4,
                                    ),
                                                Icon(Icons.open_in_new_off_rounded,
                                        size: 8, color: MYcolors.cyan60001),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    )),
                Visibility(
                  visible: doctor!.timeSlots!.isNotEmpty,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: getPadding(top: 17),
                        child: Text("Consultation timings (for this week)",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: AppStyle.txtUrbanistRomanBold20),
                      ),
                      // Padding(
                      //   padding: getPadding(top: 32),
                      //   child: SingleChildScrollView(
                      //     scrollDirection: Axis.horizontal,
                      //     child: Row(
                      //       children: List<Widget>.generate(doctor!.timeSlots!.length, (index) {
                      //         return Container(
                      //           margin: getMargin(right: CustomSpacer.XS),
                      //           padding: getPadding(
                      //               left: 12, top: 13, right: 12, bottom: 13),
                      //           decoration: BoxDecoration(
                      //               color: MYcolors.gray200,
                      //               borderRadius: BorderRadius.circular(8)),
                      //           child: Column(
                      //               mainAxisSize: MainAxisSize.min,
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               mainAxisAlignment: MainAxisAlignment.center,
                      //               children: [
                      //                 Padding(
                      //                   padding: getPadding(top: 1),
                      //                   child: Text(
                      //                       "${DateFormat('MMMM d').format(DateTime.fromMillisecondsSinceEpoch(doctor!.timeSlots![index].timestamp!)  )}",
                      //                       overflow: TextOverflow.ellipsis,
                      //                       textAlign: TextAlign.left,
                      //                       style: AppStyle.txtUrbanistRegular10
                      //                           .copyWith(
                      //                               color: MYcolors.bluecolor)),
                      //                 ),
                      //                 Padding(
                      //                   padding: getPadding(left: 1, top: 2),
                      //                   child: Text(
                      //                       "${DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(doctor!.timeSlots![index].timestamp!))}",
                      //                       overflow: TextOverflow.ellipsis,
                      //                       textAlign: TextAlign.left,
                      //                       style: AppStyle
                      //                           .txtUrbanistRomanBold18),
                      //                 )
                      //               ]),
                      //         );
                      //       }),
                      //     ),
                      //   ),
                      // ),
                      Padding(
                        padding: getPadding(top: 32, bottom: 5),
                        child: Wrap(
                          runSpacing: getVerticalSize(5),
                          spacing: getHorizontalSize(5),
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children:
                              List<Widget>.generate(doctor!.timeSlots!.length, (index) => timeChip(doctor!.timeSlots![index].dayName!)),
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

  Widget timeChip(time) {
    return RawChip(
      padding: getPadding(
        left: 25,
        right: 25,
      ),
      showCheckmark: false,
      labelPadding: EdgeInsets.zero,
      label: Text(
        time,
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
