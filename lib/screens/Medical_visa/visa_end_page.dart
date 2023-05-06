// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/routes.dart';

import '../../constants/colors.dart';

class Visa_submit_page extends StatelessWidget {
  const Visa_submit_page({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(CustomSpacer.S),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Center(
              child: Text(
                "Thank you !".tr,
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            CustomSpacer.s(),
            Text(
              "For uploading the tickets and visa ,we will get to you soon after confirming the hotel and cab service",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: MYcolors.blacklightcolors),
              textAlign: TextAlign.center,
            ),
            Spacer(),
            Text(
              "You can check out some of our \npatient's stories".tr,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    // color: MYcolors.greencolor,
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.only(right: CustomSpacer.S),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: MYcolors.whitecolor,
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                          "Images/P1.jpg",
                        ),
                      ),
                    ),
                  );
                },

              ),
            ),
                CustomSpacer.s(),
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.home);
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                      minimumSize: Size(double.infinity, 40)),
                  child: Text(
                    "Go to Home".tr,
                    style: TextStyle(
                      color: MYcolors.whitecolor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
          ]),
        ),
      ),
    );
  }
}
