import 'dart:io';

import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/CustomAutocomplete.dart';
import 'package:MyMedTrip/components/FormLabel.dart';
import 'package:MyMedTrip/components/TranslatedText.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/colors.dart';

class Generate_New_Query extends StatefulWidget {
  const Generate_New_Query({super.key});

  @override
  State<Generate_New_Query> createState() => _Generate_New_QueryState();
}

class _Generate_New_QueryState extends State<Generate_New_Query> {
  late QueryController controller;
  late bool _queryForSomeone = false;
  final ImagePicker _picker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<QueryController>();
    controller.queryType = 1; // 1 => for Query::TYPE_QUERY, 2 for Query::TYPE_MEDICAL_VISA
  }

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
        title: Text("Generate New Query", style: AppStyle.txtUrbanistRomanBold20),
        centerTitle: true,
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
            keyboardDismissBehavior:
                ScrollViewKeyboardDismissBehavior.onDrag,
            child: GetBuilder<QueryController>(builder: (controller) {
              return Form(
                // key: controller.generateQueryForm.value,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: _queryForSomeone,
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FormLabel(
                          "Name",
                        ),
                        CustomSpacer.s(),
                        CustomAutocomplete(
                          searchTable: "patient_family_details",
                          selectedId: controller.patientFaminlyId,
                          isRequired: _queryForSomeone,
                        ),
                      ],
                    )),
                    CustomSpacer.s(),
                    const FormLabel("Brief history of patient"),
                    CustomSpacer.s(),
                    TextFormField(
                      textAlign: TextAlign.start,
                      minLines: 5,
                      maxLines: 10,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      onChanged: (text) {
                        controller.briefHistory.value = text;
                      },
                    ),
                    CustomSpacer.s(),
                    Row(
                      children: const [
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
                      padding: const EdgeInsets.only(left: CustomSpacer.XS),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        underline: const Divider(
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
                                  title: const Text('Open Camera'),
                                  onPressed: (_) async {
                                    try{
                                      final XFile? cameraImage = await _picker.pickImage(
                                          source: ImageSource.camera
                                      );
                                      if(cameraImage == null) return;
                                      String? imagePath = await FirebaseFunctions.uploadImage(File(cameraImage.path));
                                      if(imagePath!= null){
                                        controller.medicalVisaPath = [imagePath];
                                        controller.update();
                                      }
                                    }catch(e){
                                      print(e.toString());
                                    }finally{
                                      Get.back();
                                    }
                                  },
                                ),
                                BottomSheetAction(
                                  title: const Text('Choose file from Library'),
                                  onPressed: (_) async {
                                    try{
                                      FilePickerResult? result =
                                      await FilePicker.platform.pickFiles(
                                        dialogTitle: "Upload medical visa",
                                        type: FileType.custom,
                                        allowMultiple: true,
                                        allowedExtensions: [
                                          'pdf','docx'
                                        ],
                                      );
                                      if (result != null) {
                                        List<File> files= [];
                                        result.files.forEach((element) {
                                          files.add(File(element.path!));
                                        });
                                        List<String>? filesPaths = await FirebaseFunctions.uploadMultipleFiles(files);
                                        controller.medicalVisaPath = filesPaths!;
                                        controller.update();
                                      } else {
                                        // User canceled the picker
                                      }
                                    }catch(e){
                                      print(e);
                                    }finally{
                                      Get.back();
                                    }
                                  },
                                ),
                                BottomSheetAction(
                                  title: const Text('Remove Photo',
                                      style: TextStyle(
                                          color: MYcolors.redcolor)),
                                  onPressed: (_) {
                                    controller.medicalVisaPath = [];
                                    controller.update();
                                    Get.back();
                                  },
                                ),
                              ],
                              cancelAction: CancelAction(
                                  title: const Text(
                                'Cancel',
                                style: TextStyle(color: MYcolors.redcolor),
                              )),
                            );
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                    color: MYcolors.blackcolor, width: 0.2),
                              ),
                              height: 100,
                              width: 100,
                              child: Builder(builder: (context) {
                                if (controller.medicalVisaPath != "") {
                                  if (controller.medicalVisaPath[0]
                                          .split('.')
                                          .last ==
                                      'pdf') {
                                    return Image.asset(
                                        'assets/icons/pdf_file.png');
                                  }
                                  return Image.network(controller.medicalVisaPath[0]);
                                }
                                return const Icon(Icons.add);
                              })),
                        ),
                        CustomSpacer.s(),
                        const Icon(
                          Icons.info_outline_rounded,
                        ),
                        CustomSpacer.xs(),
                        Expanded(
                          child: TranslatedText(
                            text: "Upload medical documents",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
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
                                  title: const Text('Open Camera'),
                                  onPressed: (_) async {
                                    try{
                                      final XFile? cameraImage = await _picker.pickImage(
                                          source: ImageSource.camera
                                      );
                                      if(cameraImage == null) return;
                                      String? imagePath = await FirebaseFunctions.uploadImage(File(cameraImage.path));
                                      if(imagePath!= null){
                                        controller.passportPath = [imagePath];
                                        controller.update();
                                      }

                                    }catch(e){
                                      print(e.toString());
                                    }finally{
                                      Get.back();
                                    }
                                  },
                                ),
                                BottomSheetAction(
                                  title: const Text('Choose from Library'),
                                  onPressed: (_) async {
                                    FilePickerResult? result =
                                        await FilePicker.platform.pickFiles(
                                          allowMultiple: true,
                                      dialogTitle: "Upload medical documents",
                                      type: FileType.custom,
                                      allowedExtensions: [
                                        'jpeg',
                                        'jpg',
                                        'heic',
                                        'png',
                                        'pdf'
                                      ],
                                    );

                                    if (result != null) {
                                      List<File> files= [];
                                      result.files.forEach((element) {
                                        files.add(File(element.path!));
                                      });
                                      List<String>? filesPaths = await FirebaseFunctions.uploadMultipleFiles(files);
                                      controller.passportPath = filesPaths!;
                                      controller.update();
                                    } else {
                                      // User canceled the picker
                                    }
                                    Get.back();
                                  },
                                ),
                                BottomSheetAction(
                                  title: const Text('Remove Photo',
                                      style: TextStyle(
                                          color: MYcolors.redcolor)),
                                  onPressed: (_) {
                                    controller.passportPath = [];
                                    controller.update();
                                  },
                                ),
                              ],
                              cancelAction: CancelAction(
                                  title: const Text(
                                'Cancel',
                                style: TextStyle(color: MYcolors.redcolor),
                              )),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                  color: MYcolors.blackcolor, width: 0.2),
                            ),
                            height: 100,
                            width: 100,
                            child: controller.passportPath != ""
                                ? Image.network(controller.passportPath[0])
                                : Icon(Icons.add),
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
                        const Text(
                          "Upload passport",
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
                        width: MediaQuery.of(context).size.width -
                            (CustomSpacer.S * 2.5),
                        backgroundColor: MYcolors.greycolor,
                        onConfirmation: () {
                          controller.generateQuery();
                        }),
                    CustomSpacer.m()
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    ),
      ),
    );
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
          GestureDetector(
            onTap: (){
              setState(() {
                _queryForSomeone = false;
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !_queryForSomeone ? MYcolors.whitecolor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width * 0.45,
              child: Text(
                "Yourself",
                style: TextStyle(
                    fontFamily: "Brandon",
                    fontSize: 15,
                    color: MYcolors.blacklightcolors),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _queryForSomeone = true;
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: _queryForSomeone ? MYcolors.whitecolor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
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
