import 'dart:io';

import 'package:MyMedTrip/components/CustomAppAbrSecondary.dart';
import 'package:MyMedTrip/constants/size_utils.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/search_query_result_model.dart';
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
import 'package:logger/logger.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:image_picker/image_picker.dart';

import '../../constants/api_constants.dart';
import '../../constants/colors.dart';

class Generate_New_Query extends StatefulWidget {
  const Generate_New_Query({super.key});

  @override
  State<Generate_New_Query> createState() => _Generate_New_QueryState();
}

class _Generate_New_QueryState extends State<Generate_New_Query> {
  late QueryController controller;
  late UserController userController;
  late bool _queryForSomeone = false;
  final ImagePicker _picker = ImagePicker();
  final storageRef = FirebaseStorage.instance.ref();
  final TextEditingController selectedFamilyMemberId = TextEditingController();
  List<Result> familyMembers = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<QueryController>();
    userController = Get.put(UserController());
    controller.queryType =
        1; // 1 => for Query::TYPE_QUERY, 2 for Query::TYPE_MEDICAL_VISA
  }

  Future getFamilyMembersList(patientId) async{
    Loaders.loadingDialog();
    Response res = await GetConnect().get("$base_uri/ajax-search/patient_family_details?patient_id=$patientId", headers: {"Accepts": "application/json"});
    if(res.isOk){
      var json = res.body['data'];
      if(json.isNotEmpty) {
        SearchQueryResult result = SearchQueryResult.fromJson(json);
        if (result.list!.isNotEmpty) {
          setState(() {
            familyMembers = result.list!;
          });
          Get.back();
        }else{
          setState(() {
            familyMembers =[];
          });
          Loaders.errorDialog("No Friends or family found".tr, title: "No Data".tr);
        }
      }
    }

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
        title:
            Text("Generate New Query", style: AppStyle.txtUrbanistRomanBold20),
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
                                TextFormField(
                                  controller: selectedFamilyMemberId,
                                  readOnly: true,
                                  validator: (text){
                                    return null;
                                  },
                                  keyboardType: TextInputType.none,
                                  onTap: () async{
                                    await getFamilyMembersList(userController.user!.id);
                                    if(!context.mounted) return;
                                    if(familyMembers.isNotEmpty){
                                      SelectDialog.showModal<Result>(
                                        context,
                                        items: List.generate(familyMembers.length, (index) => familyMembers[index]),
                                        onChange: (Result selected) {
                                          setState(() {
                                            selectedFamilyMemberId.text = selected.name;
                                            controller.patientFaminlyId.value = selected.id!;
                                          });
                                        },
                                      );
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Select Friend or Family",
                                    suffixIcon: const Icon(Icons.arrow_drop_down),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    contentPadding: const EdgeInsets.symmetric(vertical: CustomSpacer.XS, horizontal: CustomSpacer.XS),
                                  ),
                                ),
                                // CustomAutocomplete(
                                //   searchTable: "patient_family_details",
                                //   selectedId: controller.patientFaminlyId,
                                //   isRequired: _queryForSomeone,
                                //   patientId: userController.user!.id,
                                // ),
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
                        const Row(
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
                          padding: const EdgeInsets.only(left: CustomSpacer.XS),
                          child: DropdownButton<String>(
                            isExpanded: true,
                            underline: const Divider(
                              height: 0,
                              thickness: 0,
                              color: Colors.transparent,
                            ),
                            items: <String>['India']
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
                                        try {
                                          final XFile? cameraImage =
                                              await _picker.pickImage(
                                                  source: ImageSource.camera);
                                          if (cameraImage == null) return;
                                          String? imagePath =
                                              await FirebaseFunctions
                                                  .uploadImage(
                                                      File(cameraImage.path), title: "Uploading Documents");
                                          if (imagePath != null) {
                                            controller.medicalVisaPath = [
                                              imagePath
                                            ];
                                            controller.update();
                                          }
                                        } catch (e) {
                                          print(e.toString());
                                        } finally {
                                          Get.back();
                                        }
                                      },
                                    ),
                                    BottomSheetAction(
                                      title: const Text(
                                          'Choose file from Library'),
                                      onPressed: (_) async {
                                        try {
                                          FilePickerResult? result =
                                              await FilePicker.platform
                                                  .pickFiles(
                                            dialogTitle: "Upload medical visa",
                                            type: FileType.custom,
                                            allowMultiple: true,
                                            allowedExtensions: ['pdf', 'docx'],
                                          );
                                          if (result != null) {
                                            List<File> files = [];
                                            result.files.forEach((element) {
                                              files.add(File(element.path!));
                                            });
                                            List<String>? filesPaths =
                                                await FirebaseFunctions
                                                    .uploadMultipleFiles(files);
                                            controller.medicalVisaPath =
                                                filesPaths!;
                                            controller.update();
                                          } else {
                                            // User canceled the picker
                                          }
                                        } catch (e) {
                                          print(e);
                                        } finally {
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
                                    if (controller.medicalVisaPath.isNotEmpty) {
                                      return fileAddedCounter(controller.medicalVisaPath.length);
                                    }
                                    return const Icon(Icons.add);
                                  }),
                              ),
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
                                        try {
                                          final XFile? cameraImage =
                                              await _picker.pickImage(
                                                  source: ImageSource.camera);
                                          if (cameraImage == null) return;
                                          String? imagePath =
                                              await FirebaseFunctions
                                                  .uploadImage(
                                                      File(cameraImage.path), title: "Uploading Documents");
                                          if (imagePath != null) {
                                            controller.passportPath = [
                                              imagePath
                                            ];
                                            controller.update();
                                          }
                                        } catch (e) {
                                          Logger().d(e);
                                        } finally {
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
                                          dialogTitle:
                                              "Upload medical documents",
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
                                          List<File> files = [];
                                          result.files.forEach((element) {
                                            files.add(File(element.path!));
                                          });
                                          List<String>? filesPaths =
                                              await FirebaseFunctions
                                                  .uploadMultipleFiles(files, title: "Uploading Documents");
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
                                child: Builder(builder: (context) {
                                  if (controller.passportPath.isNotEmpty) {
                                    return fileAddedCounter(controller.passportPath.length);
                                  }
                                  return const Icon(Icons.add);
                                })
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.06,
                            ),
                            const Icon(
                              Icons.info_outline_rounded,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.02,
                            ),
                            const Flexible(
                              child: Text(
                                "Upload passport if available",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
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
            onTap: () {
              setState(() {
                _queryForSomeone = false;
              });
            },
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: !_queryForSomeone
                    ? MYcolors.whitecolor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width * 0.45,
              child: const Text(
                "For Yourself",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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
                color:
                    _queryForSomeone ? MYcolors.whitecolor : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              height: MediaQuery.of(context).size.height * 0.04,
              width: MediaQuery.of(context).size.width * 0.38,
              child: const Text(
                "For someone else",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: MYcolors.blacklightcolors),
              ),
            ),
          )
        ],
      ),
    );
  }
}

Widget fileAddedCounter(int length){
  return Center(
      child: RichText(
        softWrap: true,
        text: TextSpan(
            text:
            "$length \n ",
            style: AppStyle.txtUrbanistRomanBold32,
            children: [
              TextSpan(
                  text: length > 1 ? "files added": "file added",
                  style: AppStyle
                      .txtUrbanistRomanBold16)
            ]),
        textAlign: TextAlign.center,
      ));
}
