// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:MyMedTrip/screens/Query/terms_and_conditions.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import '../../constants/colors.dart';
import '../../helper/FirebaseFunctions.dart';
import '../../models/query_response_model.dart';

class DoctorReplyForm extends StatefulWidget {
  const DoctorReplyForm(this.response,{super.key});
  final QueryResponse response;
  @override
  State<DoctorReplyForm> createState() => _DoctorReplyFormState();
}

class _DoctorReplyFormState extends State<DoctorReplyForm> {
  late QueryController controller;

  List<String> docPath = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<QueryController>();
  }
  @override
  Widget build(BuildContext context) {
    // if(!controller.isLoaded.value){
    //   return CircularProgressIndicator();
    // }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Html(
    data: widget.response.response!['doctor'],
    )
          ),
        ),
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
                          List<String>? filesPaths = await FirebaseFunctions.uploadMultipleFiles(files, title: "Uploading documents. Please wait.");
                          setState(() {
                            docPath = filesPaths!;
                          });
                        } else {
                          // User canceled the picker
                        }
                        Get.back();
                      },
                    ),
                    BottomSheetAction(
                      title: const Text('Remove Photo',
                          style:
                          TextStyle(color: MYcolors.redcolor)),
                      onPressed: (_) {
                        setState(() {
                          docPath = [];
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
                    if(docPath.isNotEmpty){
                      return Image.asset('assets/icons/pdf_file.png');
                    }
                    return Icon(Icons.add);
                  })

                // controller.medicalVisaPath != ""? Image.file(File(controller.medicalVisaPath)):Icon(Icons.add),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.03,
            ),
            Flexible(
              child: Text(
                docPath.isNotEmpty? "${docPath.length} documents uploaded" : "Upload the document here".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                
              ),
            )
          ],
        ),
        GetBuilder<QueryController>(
          builder: (con) {
            if(con.stepData['patient'] == null){
              return SizedBox();
            }
            return Container(
              height: 50,
              margin: EdgeInsets.only(top: CustomSpacer.XS),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: con.stepData['patient']?.length,
                  itemBuilder: (_, i){
                  return Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(CustomSpacer.XS),
                    margin: EdgeInsets.only(right: CustomSpacer.XS),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: MYcolors.blackcolor, width: 0.2),
                      image: DecorationImage(
                          image: AssetImage('assets/icons/pdf_file.png'),
                        fit: BoxFit.scaleDown,
                        onError: (_, stackTrace){
                            print(stackTrace);
                        }
                      ),
                    ),
                  );
                  }
              ),
            );
          }
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        ElevatedButton(
          onPressed: () {
            Get.to(() => Terms_and_Conditions(widget.response));
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              minimumSize: Size(double.infinity, 40),
            backgroundColor: MYcolors.bluecolor
          ),
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
    );
  }
}
