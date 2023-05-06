import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mmt_/locale/AppTranslation.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Query/query_submission_success.dart';
import 'package:mmt_/screens/login/language_page.dart';
import 'package:mmt_/screens/login/loading_page.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';

import 'bindings/InitialBinding.dart';

void main() async {
  if (Platform.isAndroid) PathProviderAndroid.registerWith();
  if (Platform.isIOS) PathProviderIOS.registerWith();
  await GetStorage.init();
  PlatformDispatcher.instance.onError = (error, stack) {
    print(error);
    return true;
  };
  runApp(GetMaterialApp(
    home: const Loading_page(),
    debugShowCheckedModeBanner: false,
    initialBinding: InitialBinding(),
    translationsKeys: AppTranslation.translationsKeys,
    locale: Get.deviceLocale,
    fallbackLocale: const Locale('en', 'US'),
    defaultTransition: Transition.leftToRightWithFade,
    title: "My Medical Trip",
    getPages: getPages,
    theme: ThemeData(
      fontFamily: "Brandon"
    ),
  ));
}
