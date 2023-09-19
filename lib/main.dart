import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:MyMedTrip/screens/update_screen/connect_coordinotor.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:MyMedTrip/firebase_options.dart';
import 'package:MyMedTrip/locale/AppTranslation.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/login/loading_page.dart';
import 'package:path_provider_android/path_provider_android.dart';
import 'package:path_provider_ios/path_provider_ios.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
// import 'package:wakelock/wakelock.dart';
import 'bindings/InitialBinding.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

FirebaseFunctions firebaseFunctions = FirebaseFunctions();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  if (Platform.isAndroid) {
    PathProviderAndroid.registerWith();
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }
  if (Platform.isIOS) {
    PathProviderIOS.registerWith();
    await Firebase.initializeApp();
  }

  firebaseFunctions.initCrashAnalytics();

  //=========== Firebase Messaging Code ==============//
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );


  FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    await firebaseFunctions.handleOnMessage(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
    await firebaseFunctions.handleOnMessageOpened(message);
  });
  FlutterCallkitIncoming.onEvent.listen((call) {
    print(call?.event);
    print(call?.body);
    if(call?.event == Event.actionCallAccept){
      Map body = call!.body;
      Get.to(() => NoCoordinator(callToken: body['id'],));
    }
  });
  await firebaseFunctions.getCurrentCall();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(GetMaterialApp(
    home: const Loading_page(),
    debugShowCheckedModeBanner: false,
    initialBinding: InitialBinding(),
    translationsKeys: AppTranslation.translationsKeys,
    locale: Get.deviceLocale,
    fallbackLocale: const Locale('en', 'US'),
    defaultTransition: Transition.fade,
    title: "My Medical Trip",
    getPages: getPages,
    theme: ThemeData(
      fontFamily: AppStyle.txtUrbanistRegular16.fontFamily,
      fontFamilyFallback: [AppStyle.txtSourceSansProSemiBold14.fontFamily!],
    ),
    smartManagement: SmartManagement.keepFactory,

  ));
}
