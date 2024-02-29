// ignore_for_file: prefer_const_constructors

import 'package:MyMedTrip/components/FileViewerScreen.dart';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/models/query_steps/doctor_reply_model.dart';
import 'package:MyMedTrip/providers/query_provider.dart';
import 'package:MyMedTrip/screens/Query/terms_and_conditions.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/scheduler/ticker.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../constants/colors.dart';
import '../../models/query_response_model.dart';

class DoctorReplyForm extends StatefulWidget {
  const DoctorReplyForm(this.response, {super.key, required this.isCompleted});
  final QueryResponse response;
  final bool isCompleted;
  @override
  State<DoctorReplyForm> createState() => _DoctorReplyFormState();
}

class _DoctorReplyFormState extends State<DoctorReplyForm> with SingleTickerProviderStateMixin{
  late bool documentRequired;
  Map<int, String> docPath = {};
  List<DoctorReplyModel> responses = [];
  late TabController controller;
  int currentIndex = 0;
  @override
  void initState() {
    // TODO: implement initState
    documentRequired = false;
    List res = widget.response.response as List;
    for (var element in res) {
      responses.add(DoctorReplyModel.fromJson(element));
    }
    documentRequired = responses.last.documentRequired && responses.last.patient == null;
    controller = TabController(length: responses.length, vsync: this);
    controller.addListener(() {
      setState(() {
        currentIndex = controller.index;
      });
    });
    super.initState();
  }

  void checkDocRequired(){
    int requiredDoc = 0;
    int uploadedDoc = 0;
    for (var element in responses) {
      if(element.documentRequired){
        requiredDoc++;
      }
      if(element.patient != null && element.patient!.isNotEmpty){
        uploadedDoc++;
      }
    }
    if(requiredDoc == uploadedDoc){
      setState(() {
        documentRequired = false;
      });
    }

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
            child: DefaultTabController(
          length: responses.length,
          child: Column(children: [
            TabBar(
              controller: controller,
                isScrollable: true,
                tabAlignment: responses.length > 2
                    ? TabAlignment.start
                    : TabAlignment.center,
                tabs: responses
                    .asMap()
                    .entries
                    .map((e) => Tab(
                          child: Text(
                            "${"Response".tr} ${e.key + 1}",
                            style: AppStyle.txtSourceSansProSemiBold18,
                          ),
                        ))
                    .toList()),
            Expanded(
              // height: 100,
              child: TabBarView(
                controller: controller,
                children: responses.map(
                  (e) {
                    String? html = e.description;
                    return Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Html(data: html),
                          ),
                        ),
                        Visibility(
                          visible: e.proformaInvoice.isNotEmpty,
                          child: TextButton(
                            onPressed: () async {
                              Get.to(() =>
                                  FileViewerScreen(fileUrl: e.proformaInvoice));
                            },
                            child: Text(
                              'Show Proforma Invoice'.tr,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  decoration: TextDecoration.underline),
                              softWrap: true,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: (responses[controller.index].patient != null && responses[controller.index].patient!.isNotEmpty),
                            child: Text("File Uploaded" )
                        )
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ]),
        )),
        Builder(
          builder: (context) {
            bool hasFile = (responses[controller.index].patient != null && responses[controller.index].patient!.isNotEmpty);
            if(documentRequired && !responses[controller.index].documentRequired){
              return SizedBox();
            }
            if(widget.isCompleted){
              return SizedBox();
            }
            return ElevatedButton(
              onPressed: () async {
                if (documentRequired) {
                  if(hasFile) return;
                  String? imagePath = await Utils.uploadFromLibrary("Upload necessary document", allowedExtensions: ['pdf']);
                  if(imagePath == null){
                    return;
                  }
                  setState(() {
                    responses[controller.index].patient = imagePath;
                  });
                  QueryResponse data = widget.response;
                  List<Map<String,dynamic>> docResponse = [];
                  responses.forEach((element) {
                    docResponse.add(element.toJson());
                  });
                  data.response = docResponse;
                  bool res = await Get.put(QueryProvider())
                      .postQueryGenerationData(data.toJson());

                  Get.back();
                  if (res) {
                    Get.showSnackbar(GetSnackBar(
                      message: "Successfully Updated".tr,
                      duration: Duration(milliseconds: 1000),
                    ));
                  }
                  else {
                    Get.showSnackbar(GetSnackBar(
                      message: "Please try again later".tr,
                      duration: Duration(milliseconds: 1500),
                    ));
                  }
                  checkDocRequired();
                }
                else {
                  Get.to(() => Terms_and_Conditions(widget.response));
                }
              },
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  minimumSize: Size(double.infinity, 40),
                  backgroundColor: documentRequired ?(hasFile ? MYcolors.blueGray700:MYcolors.bluecolor):MYcolors.bluecolor,
              ),
              child: Text(
                documentRequired
                    ? (hasFile ? "File Uploaded".tr:"Upload Document".tr)
                    : "Apply for Medical Visa".tr,
                style: TextStyle(
                  color: MYcolors.whitecolor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
        ),
      ],
    );
  }
}
