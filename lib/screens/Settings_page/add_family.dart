// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/components/CustomAutocomplete.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import 'package:mmt_/models/user_model.dart';
import 'package:mmt_/screens/Settings_page/add_family_list.dart';
import 'package:pattern_formatter/date_formatter.dart';

import '../../constants/colors.dart';

class Add_family_page extends StatefulWidget {
  const Add_family_page({super.key});

  @override
  State<Add_family_page> createState() => _Add_family_pageState();
}

class _Add_family_pageState extends State<Add_family_page> {
  final formKey = GlobalKey<FormState>();
  late LocalUser? familyMember;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    familyMember = LocalUser(id: 0, speciality: null);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: CustomAppBar(pageName: "Add Friends or Family", showDivider: true,),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.all(CustomSpacer.S),
            child: SingleChildScrollView(
              child: GetBuilder<UserController>(
                builder: (controller) {
                  return Wrap(
                    spacing: CustomSpacer.S,
                    runSpacing: CustomSpacer.S,
                    children: [
                      TextFormField(
                        onSaved: (value) {
                         familyMember?.name = value!;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Name".tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      TextFormField(
                        onSaved: (value) {
                          familyMember?.dob = value!;
                        },
                        inputFormatters: [DateInputFormatter()],
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Date of birth",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      DropdownButtonFormField(
                        value: familyMember?.gender,
                        items: const [
                          DropdownMenuItem(value: 'male', child: Text('Male'), enabled: true,),
                          DropdownMenuItem(value: 'female', child: Text('Female'),),
                          DropdownMenuItem(value: 'other', child: Text('Other'),),
                        ], onChanged: (String? value) {
                        familyMember?.gender = value!;
                      },
                        decoration: InputDecoration(
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Gender".tr,
                          border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      IntlPhoneField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.call),
                          contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Phone",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          counterText: "",
                        ),
                        onChanged: (phone) {
                          familyMember?.phoneNo = phone.completeNumber!;
                        },
                        initialCountryCode: "IN",
                      ),

                      TextFormField(
                        onSaved: (value){
                          familyMember?.relationWithPatient = value!;
                        },
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Relation with patient".tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Preferred country to for treatment".tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          formKey.currentState!.save();
                          controller.addFamily(controller.user?.id, familyMember!);
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
                  );
                }
              ),
            ),
          ),
        ),
      ),
    );
  }
}
