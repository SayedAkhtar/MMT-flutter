import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:MyMedTrip/helper/NotificationRedirectionHandler.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(NotificationResponse res) {
  print("Handling a background message: ${res.payload}");
  print("Handling a background message: ${res.input}");
}

@pragma('vm:entry-point')
void onDidReceiveNotificationResponse(NotificationResponse res) {
  // if(res.payload != null && res.payload!.isNotEmpty){
  //   Map<String, dynamic> payload = jsonDecode(res.payload!);
  //   NotificationRedirectionHandler(notificationPayload: payload);
  // }

  print(
      "Handling a background message onDidReceiveNotificationResponse: ${res.payload}");
  print("Handling a background message: ${res.actionId}");
  print("Handling a background message: ${res.input}");
  print("Handling a background message: ${res.notificationResponseType}");
}

class FirebaseFunctions {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');
  static const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  static const InitializationSettings initializationSettings =
      InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin);

  initFirebaseBackground() async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse);
  }

  static Future<String?> uploadImage(File? imageFile,
      {String? ref, String? title}) async {
    if (imageFile == null) return null;
    String path = ref ?? 'query_docs';
    try {
      final storage = FirebaseStorage.instance;
      String ext = imageFile.path.split('.').last;
      final Reference ref = storage.ref().child('$path/${DateTime.now()}.$ext');
      Get.defaultDialog(
          title: title ?? "Uploading",
          content: const CircularProgressIndicator());
      final UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() => print('Image uploaded'));

      final imageUrl = await ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      Loaders.errorDialog("Image not uploaded. Please try again.",
          title: "Opps!!");
      print('Error uploading image: $e');
    } finally {
      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
    }
    return null;
  }

  static Future<List<String>?> uploadMultipleFiles(List<File?> files,
      {String? ref, String? title}) async {
    try {
      final storage = FirebaseStorage.instance;
      Get.defaultDialog(
          title: title ?? "Uploading",
          content: const CircularProgressIndicator());
      List<String> filePaths = [];
      for (File? file in files) {
        if (file == null) continue;
        String ext = file.path.split('.').last;
        final Reference ref =
            storage.ref().child('query_docs/${DateTime.now()}.$ext');
        final UploadTask uploadTask = ref.putFile(file);
        await uploadTask.whenComplete(() => print('Image uploaded'));
        final imageUrl = await ref.getDownloadURL();
        filePaths.add(imageUrl);
        print(imageUrl);
      }

      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
      return filePaths;
    } catch (e) {
      Loaders.errorDialog("Image not uploaded. Please try again.",
          title: "Opps!!");
      print('Error uploading image: $e');
    } finally {
      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
    }
    return null;
  }

  Future handleOnMessage(RemoteMessage message, {required bool isBackground}) async {

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse res){
          if(res.payload != null && res.payload!.isNotEmpty){
            Map<String, dynamic> payload = jsonDecode(res.payload!);
            NotificationRedirectionHandler(notificationPayload: payload);
          }
        },
        onDidReceiveBackgroundNotificationResponse:
        onDidReceiveBackgroundNotificationResponse);

    if (message.data['click_action'] == 'FLUTTER_NOTIFICATION_CLICK' &&
        message.data['screen'] == 'call_screen') {
      if (message.data['trigger_type'] == 'connect_call') {
        await showCallkitIncoming(
            message.data['uuid'],
            message.data['patient_name'],
            message.data['avatar'],
            message.data['patient_phone']);
      } else {
        await FlutterCallkitIncoming.endCall(message.data['uuid']);
      }
      return;
    }
    // if (message.data['url'] != null && message.data['url'] != "") {
    //   await launchUrl(Uri.parse(message.data['url']));
    // }
    if (message.notification != null && !isBackground) {
      _showNotification(message);
      // Logger().d(message.toMap().toString());
    }
  }

  Future handleOnMessageOpened(RemoteMessage message) async {
    debugPrint("onMessageOpenedApp: ${message.data}");
    if (message.data['url'] != null && message.data['url'] != "") {
      await launchUrl(Uri.parse(message.data['url']));
    }
    if(message.data['route_name'] !=null && message.data['route_name'] != ""){
      NotificationRedirectionHandler(notificationPayload: message.data);
    }
  }

  Future<void> showCallkitIncoming(
      String uuid, String? name, String? avatar, String? phone) async {
    final params = CallKitParams(
      id: uuid,
      nameCaller: "MMT HCF",
      appName: 'MyMedTrip',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: false,
        subtitle: 'Missed call',
      ),
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: false,
        isShowLogo: false,
        ringtonePath: 'system_ringtone_default',
        backgroundColor: '#0955fa',
        backgroundUrl: 'assets/test.png',
        actionColor: '#4CAF50',
      ),
      ios: const IOSParams(
        supportsVideo: false,
        maximumCallGroups: 1,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(params);
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
    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
  print("called");
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: darwinNotificationDetails);
    if (!Platform.isIOS) {
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: jsonEncode(message.data)
      );
    }
  }

  Future<dynamic> getCurrentCall() async {
    //check current call from pushkit if possible
    var calls = await FlutterCallkitIncoming.activeCalls();
    if (calls is List) {
      if (calls.isNotEmpty) {
        return calls[0]['id'];
      } else {
        return null;
      }
    }
  }

  void initCrashAnalytics() {
    //=========== Firebase CrashAnalytics Code ==============//
    const fatalError = true;
    // Non-async exceptions
    FlutterError.onError = (errorDetails) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
        // ignore: dead_code
      }
    };
    // Async exceptions
    PlatformDispatcher.instance.onError = (error, stack) {
      if (fatalError) {
        // If you want to record a "fatal" exception
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        // ignore: dead_code
      }
      return true;
    };
  }

  static Future<void> deleteImage(String imagePath) async {
    try {
      Reference reference = FirebaseStorage.instance.ref().child(imagePath);
      await reference.delete();
      print('Image deleted successfully');
    } catch (exception, stack) {
      FirebaseCrashlytics.instance.recordError(exception, stack);
      print('Error deleting image: $e');
    }
  }
}
