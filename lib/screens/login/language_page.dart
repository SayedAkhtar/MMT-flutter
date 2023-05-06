// ignore_for_file: prefer_const_constructors

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mmt_/constants/colors.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/login/login_fingerprint.dart';

class Language_page extends StatefulWidget {
  const Language_page({super.key});

  @override
  State<Language_page> createState() => _Language_pageState();
}

class _Language_pageState extends State<Language_page> {
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  late String selectedLanguage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedLanguage = _storage.get('language') ?? 'en';
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: MYcolors.whitecolor,
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.05,
            // ),
            // Container(
            //   height: MediaQuery.of(context).size.height * 0.50,
            //   child: Lottie.asset('assets/lottie/onboarding-page.json'),
            // ),
            Spacer(),
            SizedBox(
              height: 120,
              child: AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  RotateAnimatedText('Welcome to MyMedTrip',textStyle: TextStyle(fontSize: 32)),
                  RotateAnimatedText('Добро пожаловать в MyMedTrip',textStyle: TextStyle(fontSize: 32)),
                  RotateAnimatedText('مرحبًا بك في MyMedTrip',textStyle: TextStyle(fontSize: 32)),
                  RotateAnimatedText('मायमेडट्रिप में आपका स्वागत है',textStyle: TextStyle(fontSize: 32)),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Spacer(),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Text(
                  "Language preferred".tr,
                  style: TextStyle(fontFamily: "Brandon", fontSize: 23),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => selectLanguage('en'),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                      color: selectedLanguage == 'en' ? MYcolors.greylightcolor : MYcolors.greycolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("English"),
                  ),
                ),
                GestureDetector(
                  onTap: () => selectLanguage('ar'),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                      color: selectedLanguage == 'ar' ? MYcolors.greylightcolor : MYcolors.greycolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("إنجليزي"),
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () => selectLanguage('ru'),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                      color: selectedLanguage == 'ru' ? MYcolors.greylightcolor : MYcolors.greycolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("Английский"),
                  ),
                ),
                GestureDetector(
                  onTap: () => selectLanguage('bn'),
                  child: Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height * 0.05,
                    width: MediaQuery.of(context).size.width * 0.42,
                    decoration: BoxDecoration(
                      color: selectedLanguage == 'bn' ? MYcolors.greylightcolor : MYcolors.greycolor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text("हिंदी"),
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            Text(
              "You can always change this from settings".tr,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 84, 82, 82),
                  // fontFamily: "BrandonRMed",
                  fontSize: 15),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.02,
            ),
            GestureDetector(
              onTap: () {
                Get.toNamed(Routes.login);
              },
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: MYcolors.bluecolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  "Confirm".tr,
                  style: TextStyle(
                      // fontWeight: FontWeight.bold,
                      color: MYcolors.whitecolor,
                      fontFamily: "Brandon",
                      fontSize: 18),
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  void selectLanguage(String lang){
    Locale locale = new Locale(lang);
    Get.updateLocale(locale);
    setState(() {
      selectedLanguage = lang;
    });
    _storage.set(key: 'language', value: lang);
  }
}