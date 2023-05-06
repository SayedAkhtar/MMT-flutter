// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Medical_visa/document_visa.dart';

import '../../constants/colors.dart';

class Terms_and_Conditions extends StatelessWidget {
  const Terms_and_Conditions({super.key});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(pageName: "Terms and Conditions", showDivider: true,),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Text(
              "The findings indicate that sequential analysis is appropriate to investigate a health care provider's specific style of responding. Based on the problems emerged during the sequential analysis, further exploration of the method is recommended. Nine consultations of nine different GPs were randomly selected from a sample of 1600 videotaped doctor-patient consultations, that were all rated with the Roter Interaction Analysis",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.activeQueryUploadVisa);
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: MYcolors.bluecolor),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                child: Text(
                  "Accept".tr,
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
    ));
  }
}
