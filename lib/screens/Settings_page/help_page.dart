// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/routes.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants/api_constants.dart';
import '../../constants/colors.dart';

class Need_Help_page extends StatelessWidget {
  const Need_Help_page({super.key});

  void openWhatsapp({required String text, required String number}) async {
    var whatsapp = number; //+92xx enter like this
    var whatsappURlAndroid = "whatsapp://send?phone=$whatsapp&text=$text";
    var whatsappURLIos = "https://wa.me/$whatsapp?text=${Uri.tryParse(text)}";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(whatsappURLIos))) {
        await launchUrl(Uri.parse(
          whatsappURLIos,
        ));
      } else {
        Get.snackbar("Whatsapp not installed",
            "Please install whatsapp on your device and try again.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(whatsappURlAndroid))) {
        await launchUrl(Uri.parse(whatsappURlAndroid));
      } else {
        Get.snackbar("Whatsapp not installed",
            "Please install whatsapp on your device and try again.",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  void openEmail({required String email, required String subject, required String body}) async {
    var mailURL = "mailto:$email?subject=$subject&text=$body";
    if (Platform.isIOS) {
      // for iOS phone only
      if (await canLaunchUrl(Uri.parse(mailURL))) {
        await launchUrl(Uri.parse(
          mailURL,
        ));
      } else {
        Get.snackbar("No mail not installed",
            "Please install configure mail on your device and try again.",
            snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      // android , web
      if (await canLaunchUrl(Uri.parse(mailURL))) {
        await launchUrl(Uri.parse(mailURL));
      } else {
        Get.snackbar("No mail not installed",
            "Please install configure mail on your device and try again.",
            snackPosition: SnackPosition.BOTTOM);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageName: "Need help?", showDivider: true,),
      body: SafeArea(
    child: Padding(
      padding: const EdgeInsets.all(CustomSpacer.S),
      child: Wrap(
        runSpacing: CustomSpacer.XS,
          children: [
        Container(
          padding: const EdgeInsets.all(CustomSpacer.XS),
          decoration: BoxDecoration(
            color: MYcolors.greycolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: (){
              openWhatsapp(
                text: "Hello, I have query regarding MyMedTrip.",
                number: WHATSAPP_NUMBER
              );
            },
            child: Wrap(
              runSpacing: CustomSpacer.XS,
              children: [
                Text(
                  "Chat Support",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MYcolors.bluecolor,
                    // fontFamily: "Brandon",
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Get quick answer to any app-related queries from out team",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // color: MYcolors.bluecolor,
                    // fontFamily: "Brandon",
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(CustomSpacer.XS),
          decoration: BoxDecoration(
            color: MYcolors.greycolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: (){
                Get.toNamed(Routes.supportCall);
            },
            child: Wrap(
              runSpacing: CustomSpacer.XS,
              children: [
                Text(
                  "Call Us",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MYcolors.bluecolor,
                    // fontFamily: "Brandon",
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Get quick answer to any app-related queries from out team",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(CustomSpacer.XS),
          decoration: BoxDecoration(
            color: MYcolors.greycolor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: (){
              openEmail(email: SUPPORT_EMAIL, subject: "Support mail from MyMedTrip App", body: "");
            },
            child: Wrap(
              runSpacing: CustomSpacer.XS,
              children: [
                Text(
                  "Drop on email",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MYcolors.bluecolor,
                    // fontFamily: "Brandon",
                    fontSize: 20,
                  ),
                ),
                Text(
                  "Get quick answer to any app-related queries from out team",
                  style: TextStyle(
                    fontWeight: FontWeight.normal,
                    // color: MYcolors.bluecolor,
                    // fontFamily: "Brandon",
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    ),
      ),
    );
  }
}
