// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/routes.dart';

import '../../main.dart';
import '../update_screen/connect_coordinotor.dart';

class Loading_page extends StatefulWidget {
  const Loading_page({super.key});

  @override
  State<Loading_page> createState() => _Loading_pageState();
}

class _Loading_pageState extends State<Loading_page> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  final AuthController _authController = Get.find<AuthController>();
  String trackingStatus = "";

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initConnectivity();
    checkActiveCalls();
    _animationController = AnimationController(duration: Duration(seconds: 5), vsync: this);
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // Dispose the auth controller after reaching homepage.
    _connectivitySubscription.cancel();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> initTracking() async {
    final TrackingStatus status =
    await AppTrackingTransparency.trackingAuthorizationStatus;
    // If the system can show an authorization request dialog
    setState(() => trackingStatus = "$status");
    if (status == TrackingStatus.notDetermined) {
      await Future.delayed(const Duration(milliseconds: 200));
      // Request system's tracking authorization dialog
      final TrackingStatus status =
      await AppTrackingTransparency.requestTrackingAuthorization();
      setState(() => trackingStatus = "$status");
    }

    final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
    await pushRouteAfterSplash();
  }

  Future<void> showCustomTrackingDialog(BuildContext context) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
                'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
                'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Continue'),
            ),
          ],
        ),
      );

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException {
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  Future<void> checkActiveCalls() async {
    String? uuid = await firebaseFunctions.getCurrentCall();
    print("Current Call Stack : $uuid");
    if(uuid != null && uuid.isNotEmpty){
      Get.offAll(() => NoCoordinator(callToken: uuid));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Lottie.asset('assets/lottie/splash.json',
    fit: BoxFit.fill,
    controller: _animationController,
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width,
    animate: true,
    onLoaded: (composition) {
      _animationController
        ..duration = composition.duration
        ..forward().whenComplete(() => initTracking());
    },),
    //   body: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       ElevatedButton(onPressed: ()async{
    //         await firebaseFunctions.showCallkitIncoming("uuyudadas", "Sayed", "", "917602121828");
    //       }, child: Text("Call")),
    //       ElevatedButton(onPressed: (){}, child: Text("Decline")),
    //     ],
    //   ),
    );
  }

  pushRouteAfterSplash()async {
    if(trackingStatus.isNotEmpty ){

    }
    if(_storage.get('language') != null){
     _authController.validateUserToken();
    }else{
      await Get.offAllNamed(Routes.languageSelector);
    }
  }
}
