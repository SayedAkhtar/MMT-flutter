import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:MyMedTrip/screens/TestCallScreen.dart';
import 'package:MyMedTrip/screens/connects/chat_page.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
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
import 'bindings/InitialBinding.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

Future<void> _showNotification(RemoteMessage message) async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    Random.secure().nextInt(1000).toString(),
    'Your Channel Name',
    channelDescription: 'Your Channel Description',
    importance: Importance.high,
    priority: Priority.high,
    ticker: 'ticker',
  );
  DarwinNotificationDetails darwinNotificationDetails = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  final NotificationDetails platformChannelSpecifics =
  NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title,
    message.notification?.body,
    platformChannelSpecifics,
  );
}

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

  //=========== Firebase CrashAnalytics Code ==============//
  const fatalError = true;
  // Non-async exceptions
  FlutterError.onError = (errorDetails) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordFlutterError(errorDetails);
    }
  };
  // Async exceptions
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      // If you want to record a "fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      // If you want to record a "non-fatal" exception
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };

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

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (payload) {});

    if (message.notification != null) {
      _showNotification(message);
    }
  });
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
  ));
}
