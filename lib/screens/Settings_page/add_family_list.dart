// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:MyMedTrip/components/CustomCardWithImage.dart';
import 'package:MyMedTrip/components/CustomImageView.dart';
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
        pageName: "Friends and Families",
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
              GetBuilder<UserController>(
                initState: (ctrl){
                  controller.listFamily();
                },
                  builder: (ctrl) {
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
                              child:
                                  TranslatedText(text: 'No families added yet')),
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
                            tileColor: Colors.white,
                            style: ListTileStyle.drawer,
                            title: Text(
                              controller.familiesList[index].name!,
                              style: AppStyle.txtUrbanistRomanBold24,
                            ),
                            subtitle: Row(children: [
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
                                            overflow: TextOverflow.ellipsis)),
                                    Text(' | '),
                                  ],
                                ),
                              ),
                              Text(controller.familiesList[index].phoneNo!),
                              Visibility(
                                visible:
                                    controller.familiesList[index].speciality !=
                                        null,
                                child: Row(
                                  children: [
                                    Text(' | '),
                                    Text(
                                      controller
                                              .familiesList[index].speciality ??
                                          '',
                                      style: TextStyle(
                                          overflow: TextOverflow.ellipsis),
                                    ),
                                  ],
                                ),
                              ),
                            ]),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.remove_circle_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () {
                                controller.deleteFamily(
                                    controller.familiesList[index].id);
                                controller.listFamily();
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
                      "Add  Friends and family".tr,
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
