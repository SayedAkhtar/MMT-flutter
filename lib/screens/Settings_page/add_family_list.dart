// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/ImageWithLoader.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/routes.dart';

import '../../constants/colors.dart';

class Add_Family_List_page extends GetView<UserController> {
  const Add_Family_List_page({super.key});

  @override
  Widget build(BuildContext context) {
    if(controller.familiesList.isEmpty){
      controller.listFamily();
    }
    return Scaffold(
      appBar: CustomAppBar(
    pageName: "Friends and Families",
    showDivider: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          controller.listFamily();
        },
        child: Column(
    children: [
        GetBuilder<UserController>(
          builder: (ctrl) {
            return Flexible(
              child: ListView.builder(
                  itemCount: controller.familiesList.length,
                  itemBuilder: (ctx, index) {
                    return GestureDetector(
                      onTap: () {

                      },
                      child: Row(
                        children: [
                          Container(
                            height: 120,
                            width: 140,
                            margin: EdgeInsets.symmetric(horizontal: CustomSpacer.S, vertical: CustomSpacer.XS),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: NetworkImage(controller.familiesList[index].image!),
                                ),
                                color: MYcolors.whitecolor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    // color: Color.fromARGB(255, 189, 181, 181),
                                    color: Colors.grey.withOpacity(0.5),
                                    blurRadius: 2,
                                    spreadRadius: 0,
                                    offset: Offset(0, 1),
                                  )
                                ]
                            ),
                          ),
                          RichText(
                              text: TextSpan(
                                  text: controller.familiesList[index].name,
                                style: TextStyle(
                                  // fontWeight: FontWeight.bold,
                                    color: MYcolors.blacklightcolors,
                                    fontFamily: "Brandon",
                                    fontSize: 18),
                                children: [
                                  TextSpan(text: '\n'),
                                  TextSpan(
                                    text: controller.familiesList[index].phoneNo
                                  )
                                ]
                              ),

                          ),

                        ],
                      ),
                    );
                  }),
            );
          }
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: CustomSpacer.S, vertical: CustomSpacer.XS),
          child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: MYcolors.greycolor,
                padding: EdgeInsets.symmetric(
                    vertical: CustomSpacer.S, horizontal: CustomSpacer.S),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Get.toNamed(Routes.addFamily);
              },
              child: Text(
                "Add  Friends and family".tr,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    // fontFamily: "Brandon",
                    fontSize: 20,
                    color: MYcolors.blackcolor),
              )),
        )
    ],
        ),
      ),
    );
  }
}
