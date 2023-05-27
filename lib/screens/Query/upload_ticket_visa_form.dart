// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/helper/FirebaseFunctions.dart';
import 'package:mmt_/screens/Medical_visa/visa_end_page.dart';

import '../../constants/colors.dart';
import '../../constants/query_step_name.dart';
import '../../controller/controllers/query_controller.dart';
import '../../models/query_response_model.dart';
import '../../providers/query_provider.dart';

class UploadTicketAndVisaForm extends StatefulWidget {
  const UploadTicketAndVisaForm({super.key});

  @override
  State<UploadTicketAndVisaForm> createState() =>
      _UploadTicketAndVisaFormState();
}

class _UploadTicketAndVisaFormState extends State<UploadTicketAndVisaForm> {
  late QueryProvider _provider;
  late QueryController _controller;
  late ImagePicker _picker;
  List files = [];
  List tickets = [];
  List visa = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _provider = Get.put(QueryProvider());
    _controller = Get.find<QueryController>();
    _picker = ImagePicker();
    fetchData();
  }

  void fetchData() async {
    QueryResponse data = await _provider.getQueryStepData(
        _controller.selectedQuery, QueryStep.ticketsAndVisa);
    if (data.response!.isNotEmpty) {
      if (data.response!['tickets'].isNotEmpty) {
        files = data.response!['tickets'];
      }
      if (data.response!['visa'].isNotEmpty) {
        files.addAll(data.response!['visa']);
      }
      setState(() {
        files = List.from(files.reversed);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Visibility(
            visible: files.isNotEmpty,
            child: SizedBox(
              height: 110,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: files.length,
                  itemBuilder: (_, i) {
                    return Stack(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        children: [
                          Container(
                            margin:
                                EdgeInsets.only(right: CustomSpacer.S, top: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              border: Border.all(
                                  color: MYcolors.blackcolor, width: 0.2),
                              image: DecorationImage(
                                  image: NetworkImage(
                                    files[i],
                                  ),
                                  fit: BoxFit.cover),
                            ),
                            height: MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: const SizedBox(),
                          ),
                          Positioned(
                            right: -8,
                            top: -12,
                            child: IconButton(
                              color: Colors.white,
                              onPressed: () {
                                files.removeAt(i);
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.remove_circle,
                                color: Colors.redAccent,
                              ),
                            ),
                          ),
                        ]);
                  }),
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
                                tickets.add(imagePath);
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
                                dialogTitle: "Upload medical visa",
                                type: FileType.custom,
                                allowMultiple: true,
                                allowedExtensions: ['pdf', 'docx'],
                              );
                              if (result != null) {
                                var path = result.files.single.path!;
                                File imageFile = File(result.files.single.path!);
                                String? imagePath =
                                await FirebaseFunctions.uploadImage(
                                    imageFile);
                                if (imagePath == null) return;
                                setState(() {
                                  tickets.add(imagePath);
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
                                dialogTitle: "Upload medical visa",
                                type: FileType.custom,
                                allowMultiple: true,
                                allowedExtensions: ['pdf', 'docx'],
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
            onPressed: () {
              Map<String, dynamic> data = {};
              if(visa.isNotEmpty){
                data['visa'] = visa;
              }
              if(tickets.isNotEmpty){
                data['tickets'] = tickets;
              }
              print(data);
              _controller.uploadStepData(data, QueryStep.ticketsAndVisa);
              // Get.to(Visa_submit_page());
            },
            style: ElevatedButton.styleFrom(
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
