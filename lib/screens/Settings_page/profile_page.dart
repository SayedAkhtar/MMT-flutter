// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/components/SmallIconButton.dart';
import 'package:mmt_/components/TranslatedText.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Settings_page/add_family.dart';
import 'package:mmt_/screens/Settings_page/medical_edit.dart';
import 'package:mmt_/screens/Settings_page/profile_edit.dart';

import '../../constants/colors.dart';

class Profile_Page extends GetView<UserController> {
  const Profile_Page({super.key});

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        pageName: "Profile",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomSpacer.s(),
            _userAvatar(context),
            CustomSpacer.s(),
            Container(
              constraints: BoxConstraints(
                minHeight: 450,
                maxHeight: 500,
              ),
                child: PageView(
                  controller: pageController,
                  children: [
                    Card(
                      child: _profileDetails(context),
                    ),
                    Card(
                      child: _medicalDetails(context),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    ));
  }

  Widget _userAvatar(BuildContext context){
    return Stack(children: [
      ClipOval(
        child: Material(
          color: Colors.transparent,
          child: Ink.image(
            image: AssetImage("Images/PR.png"),
            fit: BoxFit.cover,
            width: 100,
            height: 100,
            child: InkWell(onTap: () {
              // pickImageFromGallery();
            }),
          ),
        ),
      ),
      Positioned(
        bottom: 0,
        right: 4,
        child: InkWell(
          onTap: () {
            //pickImageFromGallery();
          },
          child: ClipOval(
            child: GestureDetector(
              onTap: () {
                showAdaptiveActionSheet(
                  context: context,
                  actions: <BottomSheetAction>[
                    BottomSheetAction(
                      title: Text('UploadNew Photo'.tr),
                      onPressed: (_) {},
                    ),
                    BottomSheetAction(
                      title: Text('Choose from Library'.tr),
                      onPressed: (_) {},
                    ),
                    BottomSheetAction(
                      title: Text('Remove Photo'.tr,
                          style: TextStyle(color: MYcolors.redcolor)),
                      onPressed: (_) {},
                    ),
                  ],
                  cancelAction: CancelAction(
                      title: Text(
                        'Cancel'.tr,
                        style: TextStyle(color: MYcolors.redcolor),
                      )),
                );
              },
              child: Container(
                padding: EdgeInsets.all(8),
                color: MYcolors.greylightcolor,
                child: Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }

  Widget _profileDetails(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TranslatedText(
                text: "Patient details",
                style: TextStyle(
                  color: MYcolors.bluecolor,
                  fontWeight: FontWeight.bold,
                  // fontFamily: "Brandon",
                  fontSize: 20,
                ),
              ),
              OutlinedButton(
                  onPressed: () => Get.toNamed(Routes.addPersonalDetail),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: MYcolors.blacklightcolors,
                    side: BorderSide(color: MYcolors.blacklightcolors),
                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(100))
                  ),
                  child: TranslatedText(text: "Edit")
              ),
            ],
          ),
          Table(
            columnWidths: const <int, TableColumnWidth>{
              0: FixedColumnWidth(110),
              1: FixedColumnWidth(25),
              2: FlexColumnWidth()
            },
            children: [
              TableRow(
                children: [
                  _profileKeyText( "Name",),
                  Text(":"),
                  _profileValueText(controller.user?.name)
                ]
              ),
              TableRow(
                children: [
                  _profileKeyText("DOB"),
                  Text(":"),
                  _profileValueText(controller.user?.dob),
                ]
              ),
              TableRow(
                  children: [
                    _profileKeyText("Gender"),
                    Text(":"),
                    _profileValueText(controller.user?.gender),
                  ]
              ),
              TableRow(
                  children: [
                    _profileKeyText("Contact"),
                    Text(":"),
                    _profileValueText(controller.user?.phoneNo),
                  ]
              ),
              TableRow(
                  children: [
                    _profileKeyText("Email"),
                    Text(":"),
                    _profileValueText(controller.user?.email),
                  ]
              ),
              // TableRow(
              //     children: [
              //       _profileKeyText("City"),
              //       Text(":"),
              //       _profileValueText(controller.user?.name),
              //     ]
              // ),
              TableRow(
                  children: [
                    _profileKeyText("Speciality"),
                    Text(":"),
                    _profileValueText(controller.user?.speciality),
                  ]
              ),
              TableRow(
                  children: [
                    _profileKeyText("Country"),
                    Text(":"),
                    _profileValueText(controller.user?.country),
                  ]
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _medicalDetails(BuildContext context){
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TranslatedText(
                text: "Medical details",
                style: TextStyle(
                  color: MYcolors.bluecolor,
                  fontWeight: FontWeight.bold,
                  // fontFamily: "Brandon",
                  fontSize: 20,
                ),
              ),
              OutlinedButton(
                  onPressed: () => Get.toNamed(Routes.addMedicalDetail),
                  style: OutlinedButton.styleFrom(
                      foregroundColor: MYcolors.blacklightcolors,
                      side: BorderSide(color: MYcolors.blacklightcolors),
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(100))
                  ),
                  child: TranslatedText(text: "Edit")
              ),
            ],
          ),
          Expanded(
            child: Center(
              child: Text(
                "No details available right now".tr,
                style: TextStyle(
                  // color: MYcolors.bluecolor,
                  fontWeight: FontWeight.bold,
                  // fontFamily: "Brandon",
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileKeyText(String? text){
    return Padding(
      padding: const EdgeInsets.only(bottom: CustomSpacer.S),
      child: TranslatedText(text: text,
        style: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 17
        ),
      ),
    );
  }
  Widget _profileValueText(String? text){
    return TranslatedText(text: text,
      style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 17
      ),
    );
  }
}