// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/FormLabel.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Medical_visa/document_preview.dart';
import 'package:MyMedTrip/screens/Medical_visa/proccessing_submit.dart';

import '../../constants/colors.dart';

class Document_visa_page extends StatefulWidget {
  const Document_visa_page({super.key});

  @override
  State<Document_visa_page> createState() => _Document_visa_pageState();
}

class _Document_visa_pageState extends State<Document_visa_page> {
  late QueryController _controller;

  String patient_passport = "";
  String attendant_passport = "";
  String second_attendant_passport = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = Get.find<QueryController>();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(
          pageName: "Documents for Visa",
          showDivider: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(CustomSpacer.S),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _documentUploadListTile(title: "Upload Patient's Passport here", name: 'patient_passport'),
                _documentUploadListTile(title: "Upload Attendant's Passport here", name: 'attendant_passport'),
                _documentUploadListTile(title: "Upload Second Attendant's Passport here, (If any)", name: 'second_attendant_passport'),
                CustomSpacer.m(),
                FormLabel(
                  "Where will you be applying for \nyour visa ?".tr,
                ),
                CustomSpacer.m(),
                FormLabel(
                  "Country".tr,
                ),
                TextFormField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                CustomSpacer.s(),
                FormLabel(
                  "City".tr,
                ),
                TextFormField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Get.toNamed(Routes.activeQueryProcessing);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.05,
                    decoration: BoxDecoration(
                        color: MYcolors.bluecolor,
                        borderRadius: BorderRadius.circular(100)),
                    child: Text(
                      "Submit".tr,
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
      ),
    );
  }

  Widget _documentUploadListTile({required String title, required String name}) {
    return ListTile(
      dense: false,
      contentPadding: EdgeInsets.only(left: 0.0, right: 0.0, bottom: CustomSpacer.M),
      leading: InkWell(
        onTap: () async{
          FilePickerResult? result = await FilePicker.platform.pickFiles();
          if (result != null) {
              if(name == 'patient_passport'){
                setState(() {
                  patient_passport = result.files.first.path!;
                });
              }
              if(name == 'attendant_passport'){
                setState(() {
                  attendant_passport = result.files.first.path!;
                });
              }
              if(name == 'second_attendant_passport'){
                setState(() {
                  second_attendant_passport = result.files.first.path!;
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
            width: 100,
            child: Builder(builder: (context){
              if(name == 'patient_passport'){
                if(patient_passport != ""){
                  if(patient_passport.split('.').last == 'pdf'){
                    return Image.asset('assets/icons/pdf_file.png');
                  }
                  return Image.file(File(patient_passport));
                }
              }
              if(name == 'attendant_passport'){
                if(attendant_passport != ""){
                  if(attendant_passport.split('.').last == 'pdf'){
                    return Image.asset('assets/icons/pdf_file.png');
                  }
                  return Image.file(File(attendant_passport));
                }
              }
              if(name == 'second_attendant_passport'){
                if(second_attendant_passport != ""){
                  if(second_attendant_passport.split('.').last == 'pdf'){
                    return Image.asset('assets/icons/pdf_file.png');
                  }
                  return Image.file(File(second_attendant_passport));
                }
              }
              return Icon(Icons.add);
            })
        ),
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
          onPressed: (){
            if(name == 'patient_passport'){
              setState(() {
                patient_passport = "";
              });
            }
            if(name == 'attendant_passport'){
              setState(() {
                attendant_passport = "";
              });
            }
            if(name == 'second_attendant_passport'){
              setState(() {
                second_attendant_passport = "";
              });
            }
          },
        style: IconButton.styleFrom(
          padding: EdgeInsets.all(CustomSpacer.S),
          shape: CircleBorder(
            side: BorderSide(
              color: MYcolors.greycolor
            )
          ),
        ),
          child: const Icon(Icons.delete_outline, color: MYcolors.greycolor,),
      ),
    );
  }
}
