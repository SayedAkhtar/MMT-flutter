  // ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/components/CustomAutocomplete.dart';
import 'package:mmt_/components/FormLabel.dart';
import 'package:mmt_/components/TranslatedText.dart';
import 'package:mmt_/controller/controllers/auth_controller.dart';
import 'package:mmt_/controller/controllers/query_controller.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/models/generate_query_model.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import 'package:mmt_/routes.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import '../../constants/colors.dart';

class Generate_New_Query extends StatefulWidget {
  const Generate_New_Query({super.key});

  @override
  State<Generate_New_Query> createState() => _Generate_New_QueryState();
}

class _Generate_New_QueryState extends State<Generate_New_Query> {

  late QueryController controller;
  final bool _queryForYourself = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<QueryController>();
    controller.doctorId.value = 0;
    controller.hospitalId.value = 0;
    controller.specializationId.value = 0;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        pageName: "Generate a query",
        showDivider: true,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(
            CustomSpacer.S, CustomSpacer.S, CustomSpacer.S, 0),
        child: Column(
          children: [
            _queryAssociationSelector(context),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: GetBuilder<QueryController>(
                  builder: (controller) {
                    return Form(
                      key: controller.generateQueryForm.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(child: Column(children: [
                            FormLabel(
                              "Name",
                            ),
                            CustomSpacer.s(),
                            CustomAutocomplete(
                              searchTable: "hospitals",
                              selectedId : controller.hospitalId,
                              isRequired: true,
                            ),
                          ],)),
                          CustomSpacer.s(),
                          FormLabel(
                            "Specializations",
                          ),
                          CustomSpacer.s(),
                          CustomAutocomplete(
                            searchTable: "specializations",
                              selectedId : controller.specializationId,
                            isRequired: true,
                          ),
                          CustomSpacer.s(),
                          FormLabel("Hospital"),
                          CustomSpacer.s(),
                          CustomAutocomplete(
                            searchTable: "hospitals",
                            selectedId : controller.hospitalId,
                            isRequired: true,
                          ),
                          CustomSpacer.s(),
                          FormLabel("Doctor"),
                          CustomSpacer.s(),
                          CustomAutocomplete(
                            searchTable: "doctors",
                            selectedId: controller.doctorId,
                          ),
                          CustomSpacer.s(),
                          FormLabel("Brief history of patient"),
                          CustomSpacer.s(),
                          TextFormField(
                            textAlign: TextAlign.start,
                            minLines: 5,
                            maxLines: 10,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onChanged: (text){
                              controller.briefHistory.value = text;
                            },
                          ),
                          CustomSpacer.s(),
                          Row(
                            children: [
                              Text(
                                "Country preferred to travel",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          CustomSpacer.s(),
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: MYcolors.greycolor),
                                borderRadius: BorderRadius.circular(8)),
                            width: double.infinity,
                            padding: EdgeInsets.only(left: CustomSpacer.XS),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              underline: Divider(
                                height: 0,
                                thickness: 0,
                                color: Colors.transparent,
                              ),
                              items: <String>['India', 'Africa', 'Russia', 'UAE']
                                  .map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              value: controller.preferredCountry.value,
                              onChanged: (value) {
                                controller.preferredCountry.value = value!;
                              },
                            ),
                          ),
                          CustomSpacer.s(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showAdaptiveActionSheet(
                                    context: context,
                                    actions: <BottomSheetAction>[
                                      BottomSheetAction(
                                        title: const Text('Choose from Library'),
                                        onPressed: (_) async {
                                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                                            dialogTitle: "Upload medical visa",
                                            type: FileType.custom,
                                            allowedExtensions: ['jpeg', 'jpg', 'heic', 'pdf', 'png'],
                                          );

                                          if (result != null) {
                                            controller.medicalVisaPath = result.files.single.path!;

                                            controller.update();
                                            Get.back();
                                          } else {
                                            // User canceled the picker
                                          }
                                        },
                                      ),
                                      BottomSheetAction(
                                        title: const Text('Remove Photo',
                                            style:
                                                TextStyle(color: MYcolors.redcolor)),
                                        onPressed: (_) {
                                          controller.medicalVisaPath = "";
                                          controller.update();
                                          Get.back();
                                        },
                                      ),
                                    ],
                                    cancelAction: CancelAction(
                                        title: Text(
                                      'Cancel',
                                      style: TextStyle(color: MYcolors.redcolor),
                                    )),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      border: Border.all(color: MYcolors.blackcolor, width: 0.2),
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: Builder(builder: (context){
                                    if(controller.medicalVisaPath != ""){
                                      if(controller.medicalVisaPath.split('.').last == 'pdf'){
                                        return Image.asset('assets/icons/pdf_file.png');
                                      }
                                      return Image.file(File(controller.medicalVisaPath));
                                    }
                                    return Icon(Icons.add);
                                  })
                                ),
                              ),
                              CustomSpacer.s(),
                              Icon(
                                Icons.info_outline_rounded,
                              ),
                              CustomSpacer.xs(),
                              TranslatedText(
                                text: "Upload Medical visa\n(Optional)",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          CustomSpacer.s(),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showAdaptiveActionSheet(
                                    context: context,
                                    actions: <BottomSheetAction>[
                                      BottomSheetAction(
                                        title: const Text('Choose from Library'),
                                        onPressed: (_) async {
                                          FilePickerResult? result = await FilePicker.platform.pickFiles(
                                            dialogTitle: "Upload medical visa",
                                            type: FileType.custom,
                                            allowedExtensions: ['jpeg', 'jpg', 'heic', 'png'],
                                          );

                                          if (result != null) {
                                            controller.passportPath = result.files.single.path!;
                                            controller.update();
                                          } else {
                                            // User canceled the picker
                                          }
                                        },
                                      ),
                                      BottomSheetAction(
                                        title: const Text('Remove Photo',
                                            style:
                                                TextStyle(color: MYcolors.redcolor)),
                                        onPressed: (_) {
                                          controller.passportPath = "";
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    cancelAction: CancelAction(
                                        title: Text(
                                      'Cancel',
                                      style: TextStyle(color: MYcolors.redcolor),
                                    )),
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(color: MYcolors.blackcolor, width: 0.2),
                                  ),
                                  height: 100,
                                  width: 100,
                                  child: controller.passportPath != ""? Image.file(File(controller.passportPath)):Icon(Icons.add),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.06,
                              ),
                              Icon(
                                Icons.info_outline_rounded,
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.02,
                              ),
                              Text(
                                "Upload Passport",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          CustomSpacer.s(),
                          ConfirmationSlider(
                              height: 50,
                              width: MediaQuery.of(context).size.width - (CustomSpacer.S*2.5),
                              backgroundColor: MYcolors.greycolor,
                              onConfirmation: () {
                                controller.generateQuery();
                              }),
                          CustomSpacer.m()
                        ],
                      ),
                    );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _queryAssociationSelector(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MYcolors.greycolor,
        borderRadius: BorderRadius.circular(10),
      ),
      height: MediaQuery.of(context).size.height * 0.05,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: MYcolors.whitecolor,
              borderRadius: BorderRadius.circular(8),
            ),
            height: MediaQuery.of(context).size.height * 0.04,
            width: MediaQuery.of(context).size.width * 0.45,
            child: Text(
              "yourself",
              style: TextStyle(
                  fontFamily: "Brandon",
                  fontSize: 15,
                  color: MYcolors.blacklightcolors),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width * 0.38,
              child: Text(
                "For someone",
                style: TextStyle(
                    fontFamily: "Brandon",
                    fontSize: 15,
                    color: MYcolors.blacklightcolors),
              ),
            ),
          )
        ],
      ),
    );
  }
}
