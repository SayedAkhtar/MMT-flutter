// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:MyMedTrip/components/CustomButton.dart';
import 'package:MyMedTrip/components/TranslatedText.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';

import '../../constants/colors.dart';

class Add_Family_List_page extends GetView<UserController> {
  const Add_Family_List_page({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFFedeff5),
      appBar: CustomAppBar(
        pageName: "Friends and Families".tr,
        showDivider: true,
        backFunction: () {
          Get.toNamed(Routes.setting);
        },
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.listFamily();
          controller.loading.value = true;
          controller.update();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: CustomSpacer.S),
          child: Column(
            children: [
              GetBuilder<UserController>(initState: (ctrl) {
                controller.listFamily();
              }, builder: (ctrl) {
                if (controller.loading.isTrue) {
                  return Expanded(
                      child: Center(
                    child: CircularProgressIndicator(),
                  ));
                }

                if (ctrl.familiesList.isEmpty) {
                  return Expanded(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height - 56,
                          child: Align(
                              alignment: Alignment.center,
                              child: TranslatedText(
                                  text: 'No families added yet')),
                        )
                      ],
                    ),
                  );
                }
                return Flexible(
                  flex: 1,
                  child: ListView.builder(
                      itemCount: controller.familiesList.length,
                      // separatorBuilder: (context, index) => SizedBox(height: 10,),
                      itemBuilder: (ctx, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.white12,
                            style: ListTileStyle.drawer,
                            title: Text(
                              controller.familiesList[index].name!,
                              style: AppStyle.txtUrbanistRomanBold24,
                            ),
                            subtitle: Column(
                              children: [
                                Row(children: [
                                  Visibility(
                                    visible: controller.familiesList[index]
                                            .relationWithPatient !=
                                        null,
                                    child: Row(
                                      children: [
                                        Text(
                                            controller.familiesList[index]
                                                    .relationWithPatient ??
                                                '',
                                            style: TextStyle(
                                                overflow:
                                                    TextOverflow.ellipsis)),
                                        Text(' | '),
                                      ],
                                    ),
                                  ),
                                  Text(controller.familiesList[index].phoneNo!),
                                  Visibility(
                                    visible: controller
                                            .familiesList[index].speciality !=
                                        null,
                                    child: Row(
                                      children: [
                                        Text(' | '),
                                        Text(
                                          controller.familiesList[index]
                                                  .speciality ??
                                              '',
                                          style: TextStyle(
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                                Row(
                                  children: [
                                    Visibility(
                                      visible: controller.familiesList[index].familyUserId != null,
                                        child: TextButton(
                                      child: Text("Show Status"),
                                      onPressed: () {
                                        Get.toNamed(Routes.confirmedQuery,
                                            arguments: {
                                              'family_user_id': '169'
                                            });
                                      },
                                    ))
                                  ],
                                ),
                                TextButton(
                                  child: Text(controller.familiesList[index].notificationSubscribed! ? "Un-Subscribe to Notifications": "Subscribe to Notifications"),
                                  onPressed: () {
                                      controller.updateFamilyNotificationStatus(controller.familiesList[index].id!);
                                      controller.listFamily();
                                      controller.update();
                                  },
                                )
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                Get.defaultDialog(
                                  title: "Are you sure ?".tr,
                                  content: Container(
                                    margin:
                                        EdgeInsets.only(bottom: CustomSpacer.S),
                                    child: RichText(
                                      text: TextSpan(children: [
                                        TextSpan(
                                            text: "You are about to remove".tr),
                                        TextSpan(
                                            text:
                                                " ${controller.familiesList[index].name!} "),
                                        TextSpan(
                                            text: "from your family list.".tr),
                                        TextSpan(text: "\n"),
                                        TextSpan(text: "\n"),
                                        TextSpan(text: "Note: These means".tr),
                                        TextSpan(
                                            text:
                                                " ${controller.familiesList[index].name} "),
                                        TextSpan(
                                            text:
                                                "wont receive any further notification and you wont be able to create any queries for "
                                                    .tr),
                                        TextSpan(
                                            text: controller.familiesList[index]
                                                        .gender!
                                                        .toLowerCase() ==
                                                    'female'
                                                ? 'her'.tr
                                                : 'him'.tr),
                                      ], style: AppStyle.txtUrbanistRegular18),
                                    ),
                                  ),
                                  onConfirm: () {
                                    controller.deleteFamily(
                                        controller.familiesList[index].id);
                                    controller.listFamily();
                                  },
                                  // confirm: Text("Yes, I am sure", style: AppStyle.txtSourceSansProSemiBold18,),
                                  textConfirm: "Yes, I am sure".tr,
                                  onCancel: () {},
                                  textCancel: "No, It was a mistake".tr,
                                  buttonColor: MYcolors.bluecolor,
                                );
                              },
                            ),
                          ),
                        );
                      }),
                );
              }),
              SafeArea(
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.addFamily);
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color?>(
                          MYcolors.bluecolor)),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    width: double.infinity,
                    child: Text(
                      "Add Friends and family".tr,
                      style: TextStyle(
                        color: MYcolors.whitecolor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
