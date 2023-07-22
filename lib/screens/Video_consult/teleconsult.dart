// ignore_for_file: prefer_const_constructors
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
  late List<Result> specializations;
  late TeleconsultController controller;
  Result? selectedOption;
  bool _doctorsFound = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(TeleconsultController());
    getAllSpecializations();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Video Consulting",
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
                  });
                },
                items: specializations
                    .map<DropdownMenuItem<Result>>((Result value) {
                  return DropdownMenuItem<Result>(
                    value: value,
                    child: Text(value.name!),
                  );
                }).toList()),
            // Autocomplete<Result>(
            //   displayStringForOption: Utils.displayStringForOption,
            //   optionsBuilder: (TextEditingValue textEditingValue) async {
            //     if (textEditingValue.text.isEmpty) {
            //       return [];
            //     }
            //     return specializations.where((option) => option.name!
            //         .toLowerCase()
            //         .contains(textEditingValue.text.toLowerCase()));
            //   },
            //   fieldViewBuilder: (BuildContext context,
            //       TextEditingController fieldTextEditingController,
            //       FocusNode fieldFocusNode,
            //       VoidCallback onFieldSubmitted) {
            //     if(selectedOption != null){
            //       fieldTextEditingController.text = selectedOption!.name!;
            //     }
            //     return TextFormField(
            //       controller: fieldTextEditingController,
            //       validator: (text) {
            //         return "This field is required";
            //       },
            //       decoration: InputDecoration(
            //         suffixIcon: const Icon(Icons.arrow_drop_down),
            //         border: OutlineInputBorder(
            //             borderRadius: BorderRadius.circular(8)),
            //         contentPadding: const EdgeInsets.symmetric(
            //             vertical: CustomSpacer.XS, horizontal: CustomSpacer.XS),
            //       ),
            //       focusNode: fieldFocusNode,
            //     );
            //   },
            //   optionsViewBuilder: (context, onSelected, options) => Align(
            //     alignment: Alignment.topLeft,
            //     child: Material(
            //       shape: const RoundedRectangleBorder(
            //         borderRadius:
            //             BorderRadius.vertical(bottom: Radius.circular(4.0)),
            //       ),
            //       child: SizedBox(
            //         height: 52.0 * options.length,
            //         width: MediaQuery.of(context).size.width -
            //             (CustomSpacer.S * 2), // <-- Right here !
            //         child: ListView.builder(
            //           padding: EdgeInsets.zero,
            //           itemCount: options.length,
            //           shrinkWrap: false,
            //           itemBuilder: (BuildContext context, int index) {
            //             final String option = options.elementAt(index).name!;
            //             return InkWell(
            //               onTap: () {
            //                 FocusManager.instance.primaryFocus?.unfocus();
            //                 controller.specializationId.value = options.elementAt(index).id!;
            //                 controller.getDoctors();
            //                 setState((){
            //                   selectedOption = options.elementAt(index);
            //                 });
            //
            //               },
            //               child: Card(
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(16.0),
            //                   child: Text(option),
            //                 ),
            //               ),
            //             );
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            CustomSpacer.s(),
            Row(
              children: [
                Text(
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
                child: Obx(() {
                  if (!controller.isSearchingDoctor.value) {
                    if (controller.doctors.value.isEmpty) {
                      return Center(
                        child: Text(
                          "No doctors available \nfor consultation",
                          style: AppStyle.txtUrbanistRomanBold24RedA200,
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: controller.doctors.value.length,
                        itemBuilder: (context, index) {
                          return ExpansionTile(
                            tilePadding: EdgeInsets.zero,
                            leading: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(
                                        controller.doctors.value[index].image!),
                                  ),
                                  color: MYcolors.bluecolor,
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
                            ),
                            title: Text(
                              "${controller.doctors.value[index].name!}",
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: MYcolors.blacklightcolors,
                                  fontFamily: "Brandon",
                                  fontSize: 18),
                            ),
                            subtitle: Text(
                              "${controller.doctors.value[index].experience!} years \n${controller.doctors.value[index].specialization!}",
                              style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                  color: MYcolors.blacklightcolors,
                                  fontFamily: "Brandon",
                                  fontSize: 14),
                            ),
                            children: controller.doctors.value[index].timeSlots!
                                .map((DoctorTimeSlot e) => ActionChip(
                                      backgroundColor: MYcolors.greenlightcolor,
                                      avatar: Icon(
                                        Icons.timer,
                                        color: Colors.white70,
                                      ),
                                      labelStyle:
                                          TextStyle(color: Colors.white70),
                                      label: Text("${e.dayName}"),
                                      onPressed: () {
                                        controller.confirmAppointmentSlot(
                                            e,
                                            controller
                                                .doctors.value[index].price,
                                            controller
                                                .doctors.value[index].id!);
                                      },
                                    ))
                                .toList(),
                          );
                        });
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
              ),
            ),
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
