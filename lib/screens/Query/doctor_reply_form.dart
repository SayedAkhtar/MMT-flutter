// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'package:MyMedTrip/components/FileViewerScreen.dart';
import 'package:MyMedTrip/providers/query_provider.dart';
import 'package:MyMedTrip/screens/Query/terms_and_conditions.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/colors.dart';
import '../../helper/FirebaseFunctions.dart';
import '../../models/query_response_model.dart';
import 'package:http/http.dart' as http;

class DoctorReplyForm extends StatefulWidget {
  const DoctorReplyForm(this.response, {super.key});
  final QueryResponse response;
  @override
  State<DoctorReplyForm> createState() => _DoctorReplyFormState();
}

class _DoctorReplyFormState extends State<DoctorReplyForm> {
  late bool documentRequired;
  List<String> docPath = [];
  List responses = [];
  @override
  void initState() {
    // TODO: implement initState
    documentRequired = false;
    responses = widget.response.response! as List;
    documentRequired = responses!.last['document_required'] &&
        responses!.last['patient'] == null;
    super.initState();
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
            Flexible(
              child: TabBar(
                  isScrollable: true,
                  tabs: responses
                      .asMap()
                      .entries
                      .map((e) => Tab(
                            child: Text(
                              "Response ${e.key + 1}",
                              style: AppStyle.txtSourceSansProSemiBold18,
                            ),
                          ))
                      .toList()),
            ),
            Flexible(
              // height: 100,
              child: TabBarView(
                children: responses.asMap().entries.map(
                  (e) {
                    String? html = e.value['doctor'];
                    print(e.value['proforma_invoice']);
                    return Column(
                      children: [
                        SingleChildScrollView(
                          child: Html(
                            data: html
                          ),
                        ),
                        (e.value['proforma_invoice'] != null && e.value['proforma_invoice'].isNotEmpty)?
                        TextButton(onPressed: () async {
                          Get.to(() => FileViewerScreen(fileUrl: e.value['proforma_invoice']));

                          // Response res = await GetConnect().get(e.value['proforma_invoice']);
                          // print(res.body.toString());
                        }, child: Text('Proforma Invoice'),): const SizedBox()
                      ],
                    );
                  },
                ).toList(),
              ),
            ),
          ]),
        )),

        SizedBox(
          height: MediaQuery.of(context).size.height * 0.02,
        ),
        ElevatedButton(
          onPressed: () async {
            if (documentRequired) {
              QueryResponse data = widget.response!;
              Map<String, dynamic> response = widget.response.response!;
              response['patient'] = docPath;
              data.response = response;
              bool res = await Get.put(QueryProvider())
                  .postQueryGenerationData(data.toJson());
              Get.back();
              if (res) {
                Get.showSnackbar(GetSnackBar(
                  message: "Successfully Updated".tr,
                  duration: Duration(milliseconds: 1000),
                ));
              } else {
                Get.showSnackbar(GetSnackBar(
                  message: "Please try again later".tr,
                  duration: Duration(milliseconds: 1500),
                ));
              }
            } else {
              Get.to(() => Terms_and_Conditions(widget.response));
            }
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              minimumSize: Size(double.infinity, 40),
              backgroundColor: MYcolors.bluecolor),
          child: Text(
            documentRequired ? "Submit".tr : "Apply for Medical Visa".tr,
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
