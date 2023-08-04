// ignore_for_file: prefer_const_constructors
import 'package:MyMedTrip/screens/Video_consult/appointment_booking_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/CustomAutocomplete.dart';
import 'package:MyMedTrip/components/CustomElevetedButton.dart';
import 'package:MyMedTrip/components/FormLabel.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/controller/controllers/teleconsult_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/models/doctor.dart';
import 'package:MyMedTrip/screens/Video_consult/shedule.dart';
import 'package:select_dialog/select_dialog.dart';

import '../../constants/api_constants.dart';
import '../../helper/Utils.dart';
import '../../models/search_query_result_model.dart';
import '../../theme/app_style.dart';

class TeLe_Consult_page extends StatefulWidget {
  const TeLe_Consult_page({super.key});

  @override
  State<TeLe_Consult_page> createState() => _TeLe_Consult_pageState();
}

class _TeLe_Consult_pageState extends State<TeLe_Consult_page> {
  List<Result> specializations = [];
  late TeleconsultController controller;
  Result? selectedOption;
  bool _doctorsFound = false;
  bool isPopularDoctors = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(TeleconsultController());
    getAllSpecializations();
    getPopularDoctors();
  }

  void getAllSpecializations() async {
    Response res = await GetConnect().get(
        "$base_uri/ajax-search/specializations",
        headers: {"Accepts": "application/json"});
    if (res.isOk) {
      var json = res.body['data'];
      if (json.isNotEmpty) {
        SearchQueryResult result = SearchQueryResult.fromJson(json);
        if (result.list!.isNotEmpty) {
          setState(() {
            specializations = result.list!;
          });
        } else {
          setState(() {
            specializations = [];
          });
        }
      }
    }
  }

  void getPopularDoctors() async {
    controller.getPopularDoctors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Video Consultation",
        showDivider: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormLabel(
              "Specializations",
            ),
            CustomSpacer.s(),
            DropdownButtonFormField<Result>(
                isExpanded: true,
                value: selectedOption,
                style: AppStyle.txtUrbanistRegular16WhiteA700,
                elevation: 16,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  // prefixIcon: Icon(Icons.call),
                  hintText: "Select Specialization".tr,
                  // hintStyle: TextStyle(fontSize: 13),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onChanged: (Result? value) {
                  // This is called when the user selects an item.
                  FocusManager.instance.primaryFocus?.unfocus();
                  controller.specializationId.value = value!.id!;
                  controller.getDoctors();
                  setState(() {
                    selectedOption = value;
                    isPopularDoctors = false;
                  });
                },
                items: specializations
                    .map<DropdownMenuItem<Result>>((Result value) {
                  return DropdownMenuItem<Result>(
                    value: value,
                    child: Text(value.name!),
                  );
                }).toList()),
            CustomSpacer.s(),
            Row(
              children: [
                isPopularDoctors
                    ? Text(
                        "Popular Doctors",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      )
                    : Text(
                        "Doctors",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                CustomSpacer.s(),
                Obx(
                  () => controller.doctors.value.length > 0
                      ? Text(
                          "( Found ${controller.doctors.value.length} doctor )",
                          style: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 16,
                          ),
                        )
                      : SizedBox(),
                ),
              ],
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Obx(() {
                  if (!controller.isSearchingDoctor.value) {
                    if (controller.doctors.value.isEmpty) {
                      return Center(
                        child: Text(
                          "Please select the \nspecialty from the list",
                          style: AppStyle.txtUrbanistRomanBold24RedA200,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: controller.doctors.value.length,

                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 15,
                            shadowColor: MYcolors.bluecolor.withAlpha(80),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            child: Padding(
                              padding: const EdgeInsets.all(CustomSpacer.S),
                              child: Wrap(
                                runSpacing: 10,
                                children: [
                                  Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundImage:
                                        const AssetImage("Images/PR.png"),
                                        foregroundImage:
                                        controller.doctors.value[index].image! != null
                                            ? NetworkImage(
                                            controller.doctors.value[index].image!)
                                            : const AssetImage("Images/PR.png")
                                        as ImageProvider,
                                        minRadius: 30,
                                      ),
                                      CustomSpacer.s(),
                                      Wrap(
                                        // crossAxisAlignment: CrossAxisAlignment.start,
                                        direction: Axis.vertical,
                                        clipBehavior: Clip.hardEdge,
                                        runSpacing: 8.0,
                                        spacing: 4.0,
                                        children: [
                                          Text(
                                            "${controller.doctors.value[index].name!}",
                                            style: AppStyle.txtUrbanistRomanBold24,
                                          ),
                                          Text(
                                            "${controller.doctors.value[index].experience!} Years Of Experience",
                                            style: AppStyle.txtUrbanistRegular16,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      CustomSpacer.xs(),
                                      Icon(Icons.favorite_border_outlined),
                                      CustomSpacer.xs(),
                                      Flexible(
                                        child: Text(
                                          "${controller.doctors.value[0].specialization!.join(', ')} ",
                                          style: AppStyle.txtUrbanistRegular18
                                              .copyWith(fontWeight: FontWeight.w500),
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                        ),
                                      )
                                    ],
                                  ),
                                  Visibility(
                                    visible: controller
                                        .doctors.value[0].hospitals!.isNotEmpty,
                                    child: Row(
                                      children: [
                                        CustomSpacer.xs(),
                                        Icon(Icons.location_on),
                                        CustomSpacer.xs(),
                                        Flexible(
                                          child: Text(
                                            "${controller.doctors.value[0].hospitals!.take(3).join(", ")}",
                                            style: AppStyle.txtUrbanistRegular18
                                                .copyWith(fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      TextButton(onPressed: (){
                                        Get.to(() => AppointmentBookingWidget(doctor: controller.doctors[index],));
                                      }, child: Text("Book Now"))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );

                        });
                  } else {
                    return SizedBox();
                  }
                }),
              ),
            ),
            // Expanded(
            //   child: Container(
            //     child: Obx(() {
            //       if (controller.isSearchingDoctor.value) {
            //         return Center(child: CircularProgressIndicator());
            //       } else {
            //         return SizedBox();
            //       }
            //     }),
            //   ),
            // ),
            // Spacer(),
            Container(
              // alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "Please remember that there is may be charge applied to video consulting",
                style: TextStyle(
                    // color: MYcolors.whitecolor,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
