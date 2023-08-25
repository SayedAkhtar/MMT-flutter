// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:MyMedTrip/constants/constants.dart';
import 'package:MyMedTrip/models/query_response_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/FormLabel.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:logger/logger.dart';
import 'package:select_dialog/select_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/api_constants.dart';
import '../../constants/colors.dart';

class EditDocumentForVisaForm extends StatefulWidget {
  const EditDocumentForVisaForm(this.response, {super.key});
  final QueryResponse response;
  @override
  State<EditDocumentForVisaForm> createState() =>
      _EditDocumentForVisaFormState();
}

class _EditDocumentForVisaFormState extends State<EditDocumentForVisaForm> {
  late QueryController _controller;

  String patientPassport = "";
  List<dynamic> attendantPassport = [];
  String secondAttendantPassport = "";
  String selectedCountry = "";
  String selectedCity = "";
  String? vil = "";
  List<String> cityNames = [];
  @override
  void initState() {
    // TODO: implement initState
    selectedCountry = widget.response.response!['country'];
    patientPassport = widget.response.response!['passport'];
    attendantPassport = widget.response.response!['attendant_passport'];
    selectedCity = widget.response.response!['city'];
    vil = widget.response.response!['vil'];
    buildCountryOption(Constants.countryIdMap[selectedCountry.toLowerCase()]!);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  buildCountryOption(int countryId) async {
    var t = await GetConnect(allowAutoSignedCert: true)
        .get('$base_uri/ajax-search/cities?country_id=$countryId');
    List<String> temp = [];
    Logger().d(t.statusText);
    if (t.statusCode == 200) {
      t.body['data'].forEach((element) {
        temp.add(element['name']);
      });
    }
    setState(() {
      cityNames = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Builder(builder: (ctrl) {
          return Padding(
            padding: const EdgeInsets.all(CustomSpacer.S),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                  visible: vil!=null && vil!.isNotEmpty,
                  child: GestureDetector(
                      onTap: () async {
                        if (Platform.isIOS) {
                          // for iOS phone only
                          if (await canLaunchUrl(Uri.parse(vil!))) {
                            await launchUrl(Uri.parse(
                              vil!,
                            ));
                          } else {
                            Get.snackbar("Cannot Open","",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        } else {
                          // android , web
                          if (await canLaunchUrl(Uri.parse(vil!))) {
                            await launchUrl(Uri.parse(vil!));
                          } else {
                            Get.snackbar("Cannot Open","",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        }
                      },
                      child: Container(margin: EdgeInsets.only(bottom: CustomSpacer.L),child: Image.asset('assets/icons/pdf_file.png'))
                  ),
                ),
                _documentUploadListTile(
                    title: "Upload Edit Patient's Passport here",
                    name: 'patient_passport'),
                _documentUploadListTile(
                    title: "Upload Attendant's Passport here",
                    name: 'attendant_passport'),
                _documentUploadListTile(
                    title: "Upload Second Attendant's Passport here, (If any)",
                    name: 'second_attendant_passport'),
                CustomSpacer.m(),
                FormLabel(
                  "Where will you be applying for \nyour visa ?".tr,
                ),
                CustomSpacer.m(),
                FormLabel(
                  "Country".tr,
                ),
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
                    items: <String>['India'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    value: selectedCountry.isNotEmpty ? selectedCountry : "",
                    onChanged: (value) {
                      setState(() {
                        selectedCountry = value!;
                      });
                      buildCountryOption(
                          Constants.countryIdMap[value!.toLowerCase()]!);
                    },
                  ),
                ),
                CustomSpacer.s(),
                FormLabel(
                  "City".tr,
                ),
                GestureDetector(
                  onTap: () {
                    SelectDialog.showModal<String>(
                      context,
                      label: "Select City",
                      selectedValue: selectedCountry,
                      items: List.generate(
                          cityNames.length, (index) => cityNames[index]),
                      onChange: (String selected) {
                        setState(() {
                          selectedCity = selected;
                        });
                      },
                    );
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.only(
                        left: 15, bottom: 15, top: 11, right: 15),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withAlpha(60)),
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      selectedCity.isEmpty ? "Select City".tr : selectedCity,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _documentUploadListTile(
      {required String title, required String name}) {
    return ListTile(
      dense: false,
      contentPadding:
          EdgeInsets.only(left: 0.0, right: 0.0, bottom: CustomSpacer.M),
      leading: InkWell(
        onTap: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            File file = File(result.files.single.path!);
            String? uploadedPath = await FirebaseFunctions.uploadImage(file);
            if (uploadedPath == null) {
              return;
            }
            if (name == 'patient_passport') {
              setState(() {
                patientPassport = uploadedPath;
              });
            }
            if (name == 'attendant_passport') {
              setState(() {
                attendantPassport.add(uploadedPath);
              });
            }
            if (name == 'second_attendant_passport') {
              setState(() {
                attendantPassport.add(uploadedPath);
              });
            }
            // _controller.uploadVisaDocuments(path: result.files.first.path!, name: name);
            // File file = File();
          } else {
            // User canceled the picker
          }
        },
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(color: MYcolors.blackcolor, width: 0.2),
            ),
            height: 100,
            width: 60,
            child: Builder(builder: (context) {
              if (name == 'patient_passport') {
                if (patientPassport != "") {
                  // if(patient_passport.split('.').last == 'pdf'){
                  return Image.asset('assets/icons/pdf_file.png');
                  // }
                  // return Image.file(File(patient_passport));
                }
              }
              if (name == 'attendant_passport') {
                if (attendantPassport.isNotEmpty) {
                  // if(attendant_passport.split('.').last == 'pdf'){
                  return Image.asset('assets/icons/pdf_file.png');
                  // }
                  // return Image.file(File(attendant_passport));
                }
              }
              if (name == 'second_attendant_passport') {
                if (attendantPassport.asMap().containsKey(1)) {
                  // if(second_attendant_passport.split('.').last == 'pdf'){
                  return Image.asset('assets/icons/pdf_file.png');
                  // }
                  // return Image.file(File(second_attendant_passport));
                }
              }
              return Icon(Icons.add);
            })),
      ),
      title: Text(
        title.tr,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
        textAlign: TextAlign.center,
      ),
      trailing: TextButton(
        onPressed: () {
          if (name == 'patient_passport') {
            setState(() {
              patientPassport = "";
            });
          }
          if (name == 'attendant_passport') {
            setState(() {
              attendantPassport = [];
            });
          }
          if (name == 'second_attendant_passport') {
            setState(() {
              secondAttendantPassport = "";
            });
          }
        },
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(CustomSpacer.S),
          shape: CircleBorder(side: BorderSide(color: MYcolors.greycolor)),
        ),
        child: const Icon(
          Icons.delete_outline,
          color: MYcolors.greycolor,
        ),
      ),
    );
  }
}
