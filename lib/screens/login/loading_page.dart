// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mmt_/components/NoNetwork.dart';
import 'package:mmt_/controller/controllers/auth_controller.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/routes.dart';

class Loading_page extends StatefulWidget {
  const Loading_page({super.key});

  @override
  State<Loading_page> createState() => _Loading_pageState();
}

class _Loading_pageState extends State<Loading_page> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  late AuthController _authController;
  late StreamSubscription subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(duration: Duration(seconds: 5), vsync: this);
    _authController = Get.put(AuthController());
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
      if(result == ConnectivityResult.none){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NoNetwork()),
        );
        print("Fired this");
      }else{
        // pushRouteAfterSplash();
        print("Fired this else");
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // Dispose the auth controller after reaching homepage.
    subscription.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
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
    ));
  }

  pushRouteAfterSplash()async {
    if(_storage.get('language') != null){
     _authController.validateUserToken();
    }else{
      await Get.offAllNamed(Routes.languageSelector);
    }
  }
}
