// ignore_for_file: prefer_const_constructors

import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Query/terms_and_conditions.dart';
import 'package:lottie/lottie.dart';

import '../../constants/colors.dart';

class Proccessing_page extends StatefulWidget {
  const Proccessing_page({super.key});

  @override
  State<Proccessing_page> createState() => _Proccessing_pageState();
}

class _Proccessing_pageState extends State<Proccessing_page> with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(duration: Duration(seconds: 5), vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Expanded(
                child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height *0.30,
                    child: Lottie.asset('assets/lottie/waiting.json',
                      fit: BoxFit.fitHeight,
                      controller: animationController,
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      animate: true,
                      onLoaded: (composition) {
                        animationController
                          ..duration = composition.duration
                          ..forward();
                      },),
                  ),
                  CustomSpacer.l(),
                  Text(
                    "Please wait while we verify your\nuploaded documents",
                    style: AppStyle.txtUrbanistRomanBold24,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )),
            ElevatedButton(
                onPressed: () {
                  Get.offAllNamed(Routes.home);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: MYcolors.bluecolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    minimumSize: Size(double.infinity, 40)),
                child: Text(
                  "Proceed".tr,
                  style: AppStyle.txtRobotoRegular20.copyWith(color: Colors.white),
                ),
            ),
          ],
        ),
      ),
    );
  }
}
