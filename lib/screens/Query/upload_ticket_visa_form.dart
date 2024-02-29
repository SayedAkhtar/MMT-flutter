// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:MyMedTrip/theme/app_style.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:MyMedTrip/helper/Utils.dart';

import '../../constants/colors.dart';
import '../../constants/query_step_name.dart';
import '../../models/query_response_model.dart';
import '../../providers/query_provider.dart';

class UploadTicketAndVisaForm extends StatefulWidget {
  const UploadTicketAndVisaForm(this.response,{super.key});
  final QueryResponse response;
  @override
  State<UploadTicketAndVisaForm> createState() =>
      _UploadTicketAndVisaFormState();
}

class _UploadTicketAndVisaFormState extends State<UploadTicketAndVisaForm> {
  late QueryProvider _provider;
  late ImagePicker _picker;
  List files = [];
  List tickets = [];
  List visa = [];
  bool formSubmitted = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provider = Get.put(QueryProvider());
    _picker = ImagePicker();
    // fetchData();
  }

  @override
  Widget build(BuildContext context) {
    if(formSubmitted || widget.response.response!.isNotEmpty){
      return Scaffold(
        body: Center(child: Text("Please wait while we validate your documents. \nYou will be notified once ot is complete.".tr,
          style: AppStyle.txtUrbanistRomanBold24, textAlign: TextAlign.center,),),
      );
    }
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Visibility(
            visible: files.isNotEmpty,
            child: Column(
              children: [
                Text("Uploaded Files:".tr),
                SizedBox(
                  height: 110,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: files.length,
                      itemBuilder: (_, i) {
                        return Stack(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            children: [

                              Utils.getFirebaseFileExt(files[i]) == 'pdf'?
                              GestureDetector(
                                onTap: (){
                                  files.removeAt(i);
                                  setState(() {});
                                },
                                child: Container(
                                  margin:
                                  EdgeInsets.only(right: CustomSpacer.S, top: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: MYcolors.blackcolor, width: 0.2),
                                    image: DecorationImage(
                                        image: AssetImage(
                                            'assets/icons/pdf_file.png'
                                        ),
                                        fit: BoxFit.cover),
                                  ),
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  child: Icon(Icons.remove_circle),
                                ),
                              ):
                              GestureDetector(
                                onTap: (){
                                  files.removeAt(i);
                                  setState(() {});
                                },
                                child: Container(
                                  margin:
                                      EdgeInsets.only(right: CustomSpacer.S, top: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(7),
                                    border: Border.all(
                                        color: MYcolors.blackcolor, width: 0.2),
                                    image: DecorationImage(image: NetworkImage(
                                      files[i],
                                    ))
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                  height: MediaQuery.of(context).size.height * 0.1,
                                  width: MediaQuery.of(context).size.width * 0.2,
                                  child: Icon(Icons.remove_circle, color: Colors.redAccent,),
                                ),
                              ),

                            ]);
                      }),
                ),
              ],
            ),
          ),
          CustomSpacer.s(),
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    showAdaptiveActionSheet(
                      context: context,
                      isDismissible: true,
                      actions: <BottomSheetAction>[
                        BottomSheetAction(
                          title: Text('Upload New Photo'.tr),
                          onPressed: (_) async {
                            String? imagePath = await Utils.uploadFromCamera();
                            if(imagePath != null && imagePath.isNotEmpty){
                              setState(() {
                                tickets.add(imagePath);
                                files.add(imagePath);
                              });
                            }
                            Get.back();
                          },
                        ),
                        BottomSheetAction(
                          title: Text('Choose from Library'.tr),
                          onPressed: (_) async {
                            String? imagePath = await Utils.uploadFromLibrary("Upload medical visa".tr,
                            allowedExtensions: ['jpeg','jpg','png','pdf']
                            );
                            if (imagePath == null) return;
                            setState(() {
                              tickets.add(imagePath);
                              files.add(imagePath);
                            });
                            Get.back();
                          },
                        ),
                      ],
                      cancelAction: CancelAction(
                          title: Text(
                        'Cancel'.tr,
                        style: TextStyle(color: MYcolors.redcolor),
                      )),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border:
                            Border.all(color: MYcolors.blackcolor, width: 0.2)),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Icon(Icons.add),
                  )),
              CustomSpacer.s(),
              Text(
                "Upload ticket here".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          CustomSpacer.m(),
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    showAdaptiveActionSheet(
                      context: context,
                      actions: <BottomSheetAction>[
                        BottomSheetAction(
                          title: Text('Upload New Photo'.tr),
                          onPressed: (_) async {
                            try {
                              final XFile? cameraImage = await _picker
                                  .pickImage(source: ImageSource.camera);
                              if (cameraImage == null) return;
                              File imageFile = File(cameraImage.path);
                              String? imagePath =
                              await FirebaseFunctions.uploadImage(
                                  imageFile);
                              if (imagePath == null) return;
                              setState(() {
                                visa.add(imagePath);
                                files.add(imagePath);
                              });
                            } catch (e) {
                              print(e.toString());
                            } finally {
                              Get.back();
                            }
                          },
                        ),
                        BottomSheetAction(
                          title: Text('Choose from Library'.tr),
                          onPressed: (_) async {
                            try {
                              FilePickerResult? result =
                              await FilePicker.platform.pickFiles(
                                dialogTitle: "Upload medical visa".tr,
                                type: FileType.custom,
                                allowMultiple: true,
                                allowedExtensions: ['pdf'],
                              );
                              if (result != null) {
                                var path = result.files.single.path!;
                                File imageFile = File(result.files.single.path!);
                                String? imagePath =
                                await FirebaseFunctions.uploadImage(
                                    imageFile);
                                if (imagePath == null) return;
                                setState(() {
                                  visa.add(imagePath);
                                  files.add(imagePath);
                                });
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
                      ],
                      cancelAction: CancelAction(
                          title: Text(
                            'Cancel'.tr,
                            style: TextStyle(color: MYcolors.redcolor),
                          )),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7),
                        border:
                        Border.all(color: MYcolors.blackcolor, width: 0.2)),
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Icon(Icons.add),
                  )),
              CustomSpacer.s(),
              Text(
                "Upload visa here".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () async{

              QueryResponse data = widget.response;
              Map<dynamic, dynamic> response = widget.response.response!;
              data.currentStep = QueryStep.ticketsAndVisa;
              if(visa.isNotEmpty){
                response['visa'] = visa;
              }
              if(tickets.isNotEmpty){
                response['tickets'] = tickets;
              }
              data.response = response;
              bool res = await Get.put(QueryProvider())
                  .postQueryGenerationData(data.toJson());
              Get.back();
              if (res) {
                Get.showSnackbar(GetSnackBar(
                  message: "Successfully Updated".tr,
                  duration: Duration(milliseconds: 1000),
                ));
                setState(() {
                  formSubmitted = true;
                });
              } else {
                Get.showSnackbar(GetSnackBar(
                  message: "Please try again later".tr,
                  duration: Duration(milliseconds: 1500),
                ));
              }
              // _controller.uploadStepData(data, QueryStep.ticketsAndVisa);
              // Get.to(Visa_submit_page());
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: MYcolors.bluecolor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                minimumSize: Size(double.infinity, 40)),
            child: Text(
              "Submit".tr,
              style: TextStyle(
                color: MYcolors.whitecolor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
