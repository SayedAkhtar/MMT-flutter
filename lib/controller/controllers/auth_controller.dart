import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/providers/auth_provider.dart';
import 'package:MyMedTrip/routes.dart';

import '../../models/user_model.dart';

class AuthController extends GetxController {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  String countryCode = "";
  final gender = "male".obs;
  int loginMethod = 0;
  var isLoggedIn = false.obs;
  bool showLoginPassword = false;

  late AuthProvider _provider;
  final UserController _user = Get.find<UserController>();
  final LocalStorageController _storageController =
      Get.find<LocalStorageController>();

  @override
  void onInit() {
    super.onInit();
    _provider = Get.put(AuthProvider());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    if (!_provider.isDisposed) {
      _provider.dispose();
    }
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    passwordController.dispose();
    oldPasswordController.dispose();
  }

  int get getCurrentLoginMethod => loginMethod;

  String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void register(String name, String password, String phone, String gender, String countryCode) async {
    Map<String, dynamic> body = {
        "username": name,
        "password": password,
        "name": name,
        "phone": phone,
        "gender": gender,
        "is_active": true,
        "role": 1,
        'country_code': countryCode
      };
      LocalUser? user = await _provider.register(body);
      if (user != null) {
        _user.user = user;
        update();
        _storageController.set(key: "token", value: user.token!);
        Get.toNamed(Routes.home);
      }
  }

  void login() async {
    if (loginMethod == 0) {
      phoneLogin();
    }
  }

  void validateUserToken() async {
    if (_storageController.get('token') != null ||
        _storageController.get('token') != "") {
      Loaders.loadingDialog(title: "Checking Credentials");
      LocalUser? res =
          await _provider.checkToken(token: _storageController.get('token'));
      if (res == null) {
        await Get.offAllNamed(Routes.login);
        return;
      }
      _user.user = res;
      isLoggedIn.value = true;
      update();
      await Get.offAllNamed(Routes.home);
    } else {
      await Get.offAllNamed(Routes.login);
    }
  }

  void phoneLogin() async {
    String? language = _storageController.get('language');
      LocalUser? res = await _provider.login(
          phone: phoneController.text, password: passwordController.text, language: language);
      if (res != null) {
        _user.user = res;
        _storageController.set(key: "token", value: res.token!);
        isLoggedIn.value = true;
        phoneController.text = "";
        passwordController.text = "";
        update();
        Get.offAllNamed(Routes.home);
      }
  }

  void loginWithBiometric(String id) async{
    LocalUser? res = await _provider.loginWithBioID(
        id: id);
    if (res != null) {
      _user.user = res;
      _storageController.set(key: "token", value: res.token!);
      isLoggedIn.value = true;
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        if(Platform.isAndroid){
          final fcmToken = await FirebaseMessaging.instance.getToken();
          print(fcmToken);
          // await _provider.updateFirebase(userCredential.user!.uid, fcmToken!);
        }
        // print(fcmToken);
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "operation-not-allowed":
            print("Anonymous auth hasn't been enabled for this project.");
            break;
          default:
            print("Unknown error.");
        }
      }
      phoneController.text = "";
      passwordController.text = "";
      update();
      Get.offAllNamed(Routes.home);
    }
  }

  void logout() async {
    Loaders.loadingDialog();
    if (await _provider.logout()) {
      Get.offAllNamed(Routes.login);
    }
  }

  void setCurrentLoginMethod(method) {
    if (method == "phone") {
      loginMethod = 0;
    }
    if (method == "email") {
      loginMethod = 1;
    }
    update();
  }

  void resendOtp() async {
    await _provider.resendOtp();
  }

  void verifyOtp({required String otp}) async {
    bool res = await _provider.validateOtp(otp, phoneController.text);
    if (res) {
      Loaders.successDialog("Phone number verified successfully");
      Get.toNamed(Routes.home);
    }
  }
}
