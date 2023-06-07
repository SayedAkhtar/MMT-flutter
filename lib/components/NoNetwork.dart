import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:MyMedTrip/screens/login/loading_page.dart';
import 'package:get/get.dart';

import '../controller/controllers/local_storage_controller.dart';

class NoNetwork extends StatefulWidget {
  const NoNetwork({Key? key}) : super(key: key);

  @override
  State<NoNetwork> createState() => _NoNetworkState();
}

class _NoNetworkState extends State<NoNetwork> with TickerProviderStateMixin  {
  late AnimationController _animationController;
  late StreamSubscription subscription;
  late AuthController _authController;
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(duration: Duration(seconds: 5), vsync: this);
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
      if(result != ConnectivityResult.none){
        _authController = Get.put(AuthController());
        if(_storage.get('language') != null) {
          _authController.validateUserToken();
        }
          Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Loading_page()),
        );
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
    _animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          body: Center(
            child: Lottie.asset('assets/lottie/no-internet-connection.json',
              fit: BoxFit.fill,
              controller: _animationController,
              width: MediaQuery.of(context).size.width,
              animate: true,
              onLoaded: (composition) {
                _animationController
                  ..duration = composition.duration
                  ..repeat();
              },),
          ),
        ));
  }
}
