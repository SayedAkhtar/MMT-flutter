// ignore_for_file: prefer_const_constructors

import 'dart:io';
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
                    if(e.value['proforma_invoice'].isNotEmpty){
                      html = '$html <a href="${e.value['proforma_invoice']}" target="_blank" rel="nofollow">Proforma Invoice</a>';
                    }
                    return SingleChildScrollView(
                      child: Html(
                        data: html,
                        onAnchorTap: (String? url, Map<String, String> attributes, element) async {
                          launchUrl(Uri.parse(url!));
                        },
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ]),
        )),
        // Expanded(
        //   child: SingleChildScrollView(
        //       child: Html(
        //     data: widget.response.response!['doctor'],
        //   )),
        // ),
        // Builder(builder: (con) {
        //   if (widget.response.response!['patient'] == null) {
        //     return SizedBox();
        //   }
        //   return Column(
        //     mainAxisAlignment: MainAxisAlignment.start,
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: [
        //       Text(
        //         "Uploaded documents: ".tr,
        //         style: AppStyle.txtSourceSansProSemiBold18,
        //       ),
        //       Container(
        //         height: 50,
        //         margin: EdgeInsets.only(top: CustomSpacer.XS),
        //         child: ListView.builder(
        //             scrollDirection: Axis.horizontal,
        //             shrinkWrap: true,
        //             itemCount: widget.response.response!['patient']?.length,
        //             itemBuilder: (_, i) {
        //               return Container(
        //                 height: 50,
        //                 width: 50,
        //                 padding: EdgeInsets.all(CustomSpacer.XS),
        //                 margin: EdgeInsets.only(right: CustomSpacer.XS),
        //                 decoration: BoxDecoration(
        //                   borderRadius: BorderRadius.circular(7),
        //                   border: Border.all(
        //                       color: MYcolors.blackcolor, width: 0.2),
        //                   image: DecorationImage(
        //                       image: AssetImage('assets/icons/pdf_file.png'),
        //                       fit: BoxFit.scaleDown,
        //                       onError: (_, stackTrace) {
        //                         print(stackTrace);
        //                       }),
        //                 ),
        //               );
        //             }),
        //       ),
        //     ],
        //   );
        // }),
        // SizedBox(
        //   height: MediaQuery.of(context).size.height * 0.02,
        // ),
        // Builder(builder: (context) {
        //   if (documentRequired) {
        //     return Row(
        //       children: [
        //         GestureDetector(
        //           onTap: () {
        //             showAdaptiveActionSheet(
        //               context: context,
        //               actions: <BottomSheetAction>[
        //                 BottomSheetAction(
        //                   title: const Text('Choose from Library'),
        //                   onPressed: (_) async {
        //                     FilePickerResult? result =
        //                         await FilePicker.platform.pickFiles(
        //                       allowMultiple: true,
        //                       dialogTitle: "Upload medical documents",
        //                       type: FileType.custom,
        //                       allowedExtensions: [
        //                         'jpeg',
        //                         'jpg',
        //                         'heic',
        //                         'png',
        //                         'pdf'
        //                       ],
        //                     );
        //
        //                     if (result != null) {
        //                       List<File> files = [];
        //                       result.files.forEach((element) {
        //                         files.add(File(element.path!));
        //                       });
        //                       List<String>? filesPaths =
        //                           await FirebaseFunctions.uploadMultipleFiles(
        //                               files,
        //                               title:
        //                                   "Uploading documents. Please wait.");
        //                       setState(() {
        //                         docPath = filesPaths!;
        //                       });
        //                     } else {
        //                       // User canceled the picker
        //                     }
        //                     Get.back();
        //                   },
        //                 ),
        //                 BottomSheetAction(
        //                   title: const Text('Remove Photo',
        //                       style: TextStyle(color: MYcolors.redcolor)),
        //                   onPressed: (_) {
        //                     setState(() {
        //                       docPath = [];
        //                     });
        //                     Get.back();
        //                   },
        //                 ),
        //               ],
        //               cancelAction: CancelAction(
        //                   title: Text(
        //                 'Cancel',
        //                 style: TextStyle(color: MYcolors.redcolor),
        //               )),
        //             );
        //           },
        //           child: Container(
        //               decoration: BoxDecoration(
        //                 borderRadius: BorderRadius.circular(7),
        //                 border:
        //                     Border.all(color: MYcolors.blackcolor, width: 0.2),
        //               ),
        //               height: 100,
        //               width: 100,
        //               child: Builder(builder: (context) {
        //                 if (docPath.isNotEmpty) {
        //                   return Image.asset('assets/icons/pdf_file.png');
        //                 }
        //                 return Icon(Icons.add);
        //               })
        //
        //               // controller.medicalVisaPath != ""? Image.file(File(controller.medicalVisaPath)):Icon(Icons.add),
        //               ),
        //         ),
        //         SizedBox(
        //           width: MediaQuery.of(context).size.width * 0.03,
        //         ),
        //         Flexible(
        //           child: Text(
        //             docPath.isNotEmpty
        //                 ? "${docPath.length} documents uploaded"
        //                 : "Upload the document here".tr,
        //             style: TextStyle(
        //               fontWeight: FontWeight.bold,
        //               fontSize: 18,
        //             ),
        //           ),
        //         )
        //       ],
        //     );
        //   }
        //   return SizedBox();
        // }),
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
