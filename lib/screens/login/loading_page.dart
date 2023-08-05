// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:MyMedTrip/components/NoNetwork.dart';
import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/routes.dart';

class Loading_page extends StatefulWidget {
  const Loading_page({super.key});

  @override
  State<Loading_page> createState() => _Loading_pageState();
}

class _Loading_pageState extends State<Loading_page> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  late AuthController _authController;

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(duration: Duration(seconds: 5), vsync: this);
    _authController = Get.put(AuthController());
    initConnectivity();
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

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      log('Couldn\'t check connectivity status', error: e);
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
        ..forward().whenComplete(() => pushRouteAfterSplash());
    },),
    );
  }

  pushRouteAfterSplash()async {
    if(_storage.get('language') != null){
     _authController.validateUserToken();
    }else{
      await Get.offAllNamed(Routes.languageSelector);
    }
  }
}
