// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:MyMedTrip/components/CustomImageView.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/TranslatedText.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/routes.dart';

import '../../constants/colors.dart';

class Profile_Page extends GetView<UserController> {
  const Profile_Page({super.key});

  @override
  Widget build(BuildContext context) {
    controller.updateUserInfo(controller.user!.id);
    final PageController pageController = PageController();
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Profile".tr,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                      )
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _userAvatar(BuildContext context) {
    ImageProvider image = AssetImage("Images/PR.png");
    if (controller.user!.image != null && controller.user!.image != '') {
      image = NetworkImage(controller.user!.image!);
    }
    return Stack(children: [
      ClipOval(child: GetBuilder(
        builder: (UserController controller) {
          return SizedBox(
            width: 100,
            height: 100,
            child: CustomImageView(
              url: controller.user!.image!,
            ),
          );
        },
      )),
      Positioned(
        bottom: 0,
        right: 4,
        child: ClipOval(
          child: GestureDetector(
            onTap: () {
              showAdaptiveActionSheet(
                context: context,
                actions: <BottomSheetAction>[
                  BottomSheetAction(
                    title: Text('Upload new photo'.tr),
                    onPressed: (_) async {
                      try {
                        ImagePicker picker0 = ImagePicker();
                        final XFile? cameraImage =
                            await picker0.pickImage(source: ImageSource.camera);
                        if (cameraImage == null) return;
                        Get.back();
                        controller.updateProfileImage(
                            controller.user!.id, cameraImage.path);
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                  ),
                  BottomSheetAction(
                    title: Text('Choose from Library'.tr),
                    onPressed: (_) async {
                      try {
                        ImagePicker picker = ImagePicker();
                        final XFile? cameraImage =
                            await picker.pickImage(source: ImageSource.gallery);
                        if (cameraImage == null) return;
                        Get.back();
                        controller.updateProfileImage(
                            controller.user!.id, cameraImage.path);
                      } catch (e) {
                        print(e.toString());
                      }
                    },
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
      )
    ]);
  }

  Widget _profileDetails(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TranslatedText(
                text: "Details",
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  child: TranslatedText(text: "Edit")),
            ],
          ),
          GetBuilder<UserController>(builder: (ctrl) {
            print(ctrl.user!.treatmentCountry);
            return Table(
              columnWidths: const <int, TableColumnWidth>{
                0: FixedColumnWidth(110),
                1: FixedColumnWidth(25),
                2: FlexColumnWidth()
              },
              children: [
                TableRow(children: [
                  _profileKeyText(
                    "Name",
                  ),
                  Text(":"),
                  _profileValueText(controller.user?.name)
                ]),
                TableRow(children: [
                  _profileKeyText("DOB"),
                  Text(":"),
                  _profileValueText(Utils.formatDate(controller.user?.dob)),
                ]),
                TableRow(children: [
                  _profileKeyText("Gender"),
                  Text(":"),
                  _profileValueText(controller.user?.gender),
                ]),
                TableRow(children: [
                  _profileKeyText("Contact"),
                  Text(":"),
                  _profileValueText(controller.user?.phoneNo),
                ]),
                // TableRow(children: [
                //   _profileKeyText("Email"),
                //   Text(":"),
                //   _profileValueText(controller.user?.email),
                // ]),
                // TableRow(
                //     children: [
                //       _profileKeyText("City"),
                //       Text(":"),
                //       _profileValueText(controller.user?.name),
                //     ]
                // ),
                // TableRow(children: [
                //   _profileKeyText("Speciality"),
                //   Text(":"),
                //   _profileValueText(controller.user?.speciality),
                // ]),
                TableRow(children: [
                  _profileKeyText("Country"),
                  Text(":"),
                  _profileValueText(controller.user?.treatmentCountry),
                ]),
                // TableRow(children: [
                //   _profileKeyText("Treatment Country"),
                //   Text(":"),
                //   _profileValueText(controller.user?.treatmentCountry),
                // ])
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _medicalDetails(BuildContext context) {
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100))),
                  child: TranslatedText(text: "Edit")),
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

  Widget _profileKeyText(String? text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CustomSpacer.S),
      child: TranslatedText(
        text: text,
        style: TextStyle(fontWeight: FontWeight.normal, fontSize: 17),
      ),
    );
  }

  Widget _profileValueText(String? text) {
    return TranslatedText(
      text: text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
    );
  }
}
