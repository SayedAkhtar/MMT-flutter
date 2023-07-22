// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:MyMedTrip/constants/api_constants.dart';
import 'package:MyMedTrip/models/user_family_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/models/user_model.dart';
import 'package:logger/logger.dart';
import 'package:pattern_formatter/date_formatter.dart';
import 'package:select_dialog/select_dialog.dart';

import '../../constants/colors.dart';

class Add_family_page extends StatefulWidget {
  const Add_family_page({super.key});

  @override
  State<Add_family_page> createState() => _Add_family_pageState();
}

class _Add_family_pageState extends State<Add_family_page> {
  final formKey = GlobalKey<FormState>();
  late UserController controller;
  late UserFamily? familyMember;
  List<String> countryName = [];
  List<int> countryId = [];
  String countryPreference = '';
  @override
  void initState() {
    buildCountryOption();
    familyMember = UserFamily();
    controller = Get.find<UserController>();
    super.initState();
  }

  buildCountryOption() async {
    var t = await GetConnect(allowAutoSignedCert: true).get('$api_uri/countries');
    List<String> temp = [];
    List<int> tempOne = [];
    Logger().d(t.statusText);
    if (t.statusCode == 200) {
      t.body['DATA'].forEach((element) {
        temp.add(element['name']);
        tempOne.add(element['id']);
      });
    }
    setState(() {
      countryName = temp;
      countryId = tempOne;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Add Friends or Family",
        showDivider: true,
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.all(CustomSpacer.S),
          child: SingleChildScrollView(
            child: Wrap(
                spacing: CustomSpacer.S,
                runSpacing: CustomSpacer.S,
                children: [
                  TextFormField(
                    onSaved: (value) {
                      familyMember?.name = value!;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Name".tr,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  TextFormField(
                    onSaved: (value) {
                      familyMember?.dob =
                          Utils.formatStringToDateTime(value!);
                    },
                    inputFormatters: [DateInputFormatter()],
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Date of birth",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  DropdownButtonFormField(
                    value: familyMember?.gender,
                    items: const [
                      DropdownMenuItem(
                        value: 'male',
                        enabled: true,
                        child: Text('Male'),
                      ),
                      DropdownMenuItem(
                        value: 'female',
                        child: Text('Female'),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text('Other'),
                      ),
                    ],
                    onChanged: (String? value) {
                      familyMember?.gender = value!;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Gender".tr,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  IntlPhoneField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.call),
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Phone",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      counterText: "",
                    ),
                    onChanged: (phone) {
                      familyMember?.phoneNo = phone.completeNumber;
                    },
                    initialCountryCode: "IN",
                  ),
                  TextFormField(
                    onSaved: (value) {
                      familyMember?.relationWithPatient = value!;
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Relation with patient".tr,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      SelectDialog.showModal<String>(
                        context,
                        label: "Select Country",
                        selectedValue: countryPreference,
                        items:
                            List.generate(countryName.length, (index) => countryName[index]),
                        onChange: (String selected) {
                          familyMember?.treatmentCountry = selected;
                          setState(() {

                            countryPreference = selected;
                          });
                          
                        },
                      );
                    },
                    child: Container(
                      width: double.maxFinite,
                      padding: const EdgeInsets.only(
                          left: 15, bottom: 11, top: 11, right: 15),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      child: Text(
                        countryPreference.isEmpty ? "Select Country" : countryPreference,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      formKey.currentState!.save();
                      controller.user!.treatmentCountry =
                                countryPreference;
                      controller.addFamily(
                          controller.user?.id, familyMember!);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: MYcolors.bluecolor),
                      alignment: Alignment.center,
                      height: MediaQuery.of(context).size.height * 0.05,
                      width: MediaQuery.of(context).size.width * 0.9,
                      child: Text(
                        "Done".tr,
                        style: TextStyle(
                          color: MYcolors.whitecolor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
}
