// ignore_for_file: prefer_const_constructors

import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';

class NoCoordinator extends StatelessWidget {
 const NoCoordinator({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "No Confirmed Query".tr,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          CustomSpacer.s(),
          Text(
            "It seems that you do not have any queries confirmed. Please go to the query section to check the status of your queries.".tr,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
