// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';
import 'package:MyMedTrip/constants/constants.dart';
import 'package:MyMedTrip/constants/query_step_name.dart';
import 'package:MyMedTrip/constants/query_type.dart';
import 'package:MyMedTrip/providers/query_provider.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/FormLabel.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:logger/logger.dart';
import 'package:select_dialog/select_dialog.dart';

import '../../constants/api_constants.dart';
import '../../constants/colors.dart';

class MedicalVisaForm extends StatefulWidget {
  const MedicalVisaForm({super.key});

  @override
  State<MedicalVisaForm> createState() => _MedicalVisaFormState();
}

class _MedicalVisaFormState extends State<MedicalVisaForm> {

  String patientPassport = "";
  List<dynamic> attendantPassport = [];
  String secondAttendantPassport = "";
  String selectedCountry = "";
  String selectedCity = "";
  String fromCountry = "";
  String fromCity = "";
  List<String> cityNames = [];
  @override
  void initState() {
    // TODO: implement initState
    selectedCountry = "Select Country".tr;
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  buildCountryOption(int countryId) async {
    var t = await GetConnect(allowAutoSignedCert: true).get('$base_uri/ajax-search/cities?country_id=$countryId');
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
      appBar: CustomAppBar(pageName: "Request Medical Visa".tr, showDivider: false,),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: CustomSpacer.S),
          padding: const EdgeInsets.all(CustomSpacer.S),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text("Please fill in the complete form to apply. ",
              //   style: AppStyle.txtUrbanistRomanBold24,
              // ),
              _documentUploadListTile(
                  title: "Upload Patient's Passport here".tr,
                  name: 'patient_passport'),
              _documentUploadListTile(
                  title: "Upload Attendant's Passport here".tr,
                  name: 'attendant_passport'),
              _documentUploadListTile(
                  title: "Upload Second Attendant's Passport here, (If any)".tr,
                  name: 'second_attendant_passport'),
              CustomSpacer.m(),
              FormLabel(
                "From which country will you be applying \nfor the visa?".tr,
              ),
              CustomSpacer.m(),
              FormLabel(
                "Country".tr,
              ),
              TextFormField(
                validator: (text){
                  if(text == null || text.isEmpty){
                    return 'Required'.tr;
                  }
                  return null;
                },
                onFieldSubmitted: (String? name){
                },
                onChanged: (String? country){
                  setState(() {
                    fromCountry = country!;
                  });
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(vertical: CustomSpacer.XS, horizontal: CustomSpacer.XS),
                ),
              ),
              CustomSpacer.s(),
              FormLabel(
                "City".tr,
              ),
              TextFormField(
                validator: (text){
                  if(text == null || text.isEmpty){
                    return 'Required'.tr;
                  }
                  return null;
                },
                onFieldSubmitted: (String? name){

                },
                onChanged: (String? city){
                  setState(() {
                    fromCity = city!;
                  });
                },
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: "",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(vertical: CustomSpacer.XS, horizontal: CustomSpacer.XS),
                ),
              ),
              CustomSpacer.m(),
              FormLabel(
                "Please select your destination country \nfor travel".tr,
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
                  items: <String>['Select Country'.tr,'India']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  value: selectedCountry.isNotEmpty ? selectedCountry: "",
                  onChanged: (value) {
                    if(value == 'Select Country'.tr){
                      return;
                    }
                    setState(() {
                      selectedCountry = value!;
                    });
                    buildCountryOption(Constants.countryIdMap[value!.toLowerCase()]!);
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
                    items:
                    List.generate(cityNames.length, (index) => cityNames[index]),
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
                  child: Text( selectedCity.isEmpty?"Select City".tr : selectedCity,
                    style: const TextStyle(fontSize: 16.0),
                  ),
                ),
              ),
              CustomSpacer.m(),
              TextButton(
                onPressed: () async {
                  if(selectedCity == "Select City" || selectedCountry == "Select a country" || selectedCity.isEmpty){
                    Get.showSnackbar(GetSnackBar(
                      message: "Please select a country and a city to proceed".tr,
                      duration: Duration(seconds: 2),
                      onTap: (s){
                        Get.back(closeOverlays: false);
                      },
                    ), );
                    return;
                  }
                  // if(attendantPassport.isEmpty){
                  //   Get.showSnackbar(GetSnackBar(
                  //     message: "Attendant's passport is mandatory".tr,
                  //     duration: Duration(seconds: 2),
                  //   ));
                  //   return;
                  // }
                  Map<String, dynamic> data = {};
                  Map<String, dynamic> query = {};
                  query['passport'] = patientPassport;
                  query['attendant_passport'] = attendantPassport;
                  query['country'] = selectedCountry;
                  query['city'] = selectedCity;
                  query['from_country'] = fromCountry;
                  query['from_city'] = fromCity;
                  data['response'] = query;
                  data['current_step'] = QueryStep.documentForVisa;
                  data['type'] = QueryType.medicalVisa;
                  bool res = await Get.put(QueryProvider()).postMedicalVisaQueryData(data);
                  if(res){
                    Get.defaultDialog(
                      title: "Success".tr,
                      content: Text("A medical Query request has been successfully processed.\nPlease check the Query screen for updates on the query.".tr),
                      confirm: ElevatedButton(onPressed: (){
                        Get.offNamed(Routes.home);
                      }, child: Text("Go to Home".tr))
                    );
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.05,
                  decoration: BoxDecoration(
                      color: MYcolors.bluecolor,
                      borderRadius: BorderRadius.circular(100)),
                  child: Text(
                    "Apply for medical visa".tr,
                    style: TextStyle(
                        color: MYcolors.whitecolor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
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
          if(attendantPassport.isEmpty && name == "second_attendant_passport"){
            Get.showSnackbar(GetSnackBar(
              message: "Please upload primary attendants passport first.".tr,
              duration: Duration(seconds: 2),
            ));
            return;
          }
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
            File file = File(result.files.single.path!);
            String? uploadedPath = await FirebaseFunctions.uploadImage(file, title: "Uploading Documents".tr);
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
