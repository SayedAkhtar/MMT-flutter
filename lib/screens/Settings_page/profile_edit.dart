import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/components/CustomAutocomplete.dart';
import 'package:mmt_/constants/colors.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import 'package:pattern_formatter/date_formatter.dart';

class Profile_edit_page extends StatefulWidget {
  const Profile_edit_page({super.key});

  @override
  State<Profile_edit_page> createState() => _Profile_edit_pageState();
}

class _Profile_edit_pageState extends State<Profile_edit_page> {
  final _personalInformationKey = GlobalKey<FormState>();
  late String name, date, gender, countryPreference, phone;
  late int specializationId;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
        appBar: CustomAppBar(pageName: 'Personal Information', showDivider: false,),
      body: GetBuilder<UserController>(
        builder: (controller) {
          return Form(
            key: _personalInformationKey,
            child: Padding(
              padding: const EdgeInsets.all(CustomSpacer.S),
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: controller.user?.name,
                    onSaved: (value){controller.user?.name = value!;},
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Name".tr,
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  TextFormField(
                    initialValue: controller.user?.dob,
                    inputFormatters: [DateInputFormatter()],
                    keyboardType: TextInputType.datetime,
                    onSaved: (value){controller.user?.dob = value!;},
                    decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Date of birth".tr,
                      border:
                          OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  DropdownButtonFormField(
                    value: controller.user?.gender,
                    items: const [
                      DropdownMenuItem(value: 'male', child: Text('Male'), enabled: true,),
                      DropdownMenuItem(value: 'female', child: Text('Female'),),
                      DropdownMenuItem(value: 'other', child: Text('Other'),),
                    ], onChanged: (String? value) {
                    controller.user?.gender = value!;
                  },
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      hintText: "Date of birth".tr,
                      border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    child: TextFormField(
                      initialValue: controller.user?.phoneNo,
                      onSaved: (value){controller.user?.phoneNo = value!;},
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Contact no.".tr,
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  CustomAutocomplete(
                      searchTable: "specializations",
                      selectedId : 0.obs,
                    initialValue: controller.user?.speciality == null ? "Select Specialization": controller.user?.speciality,
                    onSelected: (Result result) {
                      controller.user?.speciality = result.name;
                        specializationId = result.id!;
                    },
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.02,
                  ),
                  Container(
                    child: TextFormField(
                      initialValue: controller.user?.treatmentCountry,
                      onSaved: (value) {controller.user?.treatmentCountry = value!;},
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                        hintText: "Preferred country to for treatment".tr,
                        border:
                            OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                  GestureDetector(
                    onTap: () {
                      _personalInformationKey.currentState?.save();
                      controller.updateUser(controller.user?.id);
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
                        style: const TextStyle(
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
          );
        }
      ),
      // backgroundColor: MYcolors.blackcolor,
    ));
  }
}
