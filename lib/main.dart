import 'dart:io';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:MyMedTrip/providers/home_provider.dart';
import 'package:MyMedTrip/screens/update_screen/connect_coordinotor.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/entities/notification_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
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
  print("Handling a background message: ${message.messageId}");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await firebaseFunctions.handleOnMessage(message);
  // await showCallkitIncoming(message.data['uuid'], message.data['patient_name'], message.data['avatar'], message.data['patient_phone']);
}
Future<void> showCallkitIncoming(String uuid, String? name, String? avatar, String? phone) async {
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
    headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
    android: const AndroidParams(
      isCustomNotification: true,
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
  await FlutterCallkitIncoming.requestNotificationPermission({
    "rationaleMessagePermission": "Notification permission is required, to show notification.",
    "postNotificationMessageRequired": "Notification permission is required, Please allow notification permission from setting."
  });
  await FlutterCallkitIncoming.showCallkitIncoming(params);
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
  // await FirebaseMessaging.instance.getToken();
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
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );


  FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    if(Platform.isIOS) {
    }
    await firebaseFunctions.handleOnMessage(message);
  });
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async{
    await firebaseFunctions.handleOnMessageOpened(message);
  });
  FlutterCallkitIncoming.onEvent.listen((call) {
    if(call?.event == Event.actionCallAccept){
      Map body = call!.body;
      Get.to(() => NoCoordinator(callToken: body['id'],));
    }
    if(call?.event == Event.actionCallDecline){
      Map body = call!.body;
      HomeProvider().disconnectCall(body['id'], "");
    }
  });

  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.library == 'image resource service' &&
        details.exception.toString().contains('404')) {
      // print('Suppressed cachedNetworkImage Exception');
      return;
    }
    FlutterError.presentError(details);
  };

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
