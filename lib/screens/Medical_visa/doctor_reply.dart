// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/controller/controllers/query_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Medical_visa/processing_page.dart';
import 'package:get/get.dart';
import '../../constants/colors.dart';

class DoctorReply extends StatefulWidget {
  DoctorReply({super.key});

  @override
  State<DoctorReply> createState() => _DoctorReplyState();
}

class _DoctorReplyState extends State<DoctorReply> {
  dynamic args = Get.arguments;
  late QueryController controller;

  String docPath = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<QueryController>();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        pageName: "Doctor's reply",
        showDivider: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: RichText(
                  text: TextSpan(
                    text: controller.doctor_response,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: MYcolors.blackcolor),
                  ),
                ),
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
                              setState(() {
                                docPath = result.files.single.path!;
                              });
                              Get.back();
                            } else {
                              Get.back();
                            }
                          },
                        ),
                        BottomSheetAction(
                          title: const Text('Remove Photo',
                              style:
                              TextStyle(color: MYcolors.redcolor)),
                          onPressed: (_) {
                            setState(() {
                              docPath = "";
                            });
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
                        if(docPath != ""){
                          if(docPath.split('.').last == 'pdf'){
                            return Image.asset('assets/icons/pdf_file.png');
                          }
                          return Image.file(File(docPath));
                        }
                        return Icon(Icons.add);
                      })

                    // controller.medicalVisaPath != ""? Image.file(File(controller.medicalVisaPath)):Icon(Icons.add),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.03,
                ),
                Text(
                  "Upload the document here".tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            ElevatedButton(
              onPressed: () {
                controller.navigateToTermsPage(docPath);
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  minimumSize: Size(double.infinity, 40)),
              child: Text(
                "Apply for Medical Visa".tr,
                style: TextStyle(
                  color: MYcolors.whitecolor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
