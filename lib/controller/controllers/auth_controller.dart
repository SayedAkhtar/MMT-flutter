import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/providers/auth_provider.dart' as api_auth;
import 'package:MyMedTrip/routes.dart';
import 'package:logger/logger.dart';

import '../../models/user_model.dart';

class AuthController extends GetxController {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  String countryCode = "";
  RxString gender = "male".obs;
  int loginMethod = 0;
  RxBool isLoggedIn = false.obs;
  bool showLoginPassword = false;
  RxBool showNewLoginPassword = false.obs;
  String otpType = 'register'; //TYPE : 'register' | 'forgot_password'

  late api_auth.AuthProvider _provider;
  late UserController _user;
  final LocalStorageController _storageController =
      Get.find<LocalStorageController>();

  @override
  void onInit() {
    super.onInit();
    _provider = Get.put(api_auth.AuthProvider());
    _user = Get.put(UserController());
    nameController = TextEditingController();
    phoneController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
  }

  @override
  void onReady() {
    super.onReady();
    phoneController = TextEditingController();
    passwordController = TextEditingController();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
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
    newPasswordController.dispose();
    showNewLoginPassword.close();
  }

  int get getCurrentLoginMethod => loginMethod;

  String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void register(String name, String password, String phone, String gender,
      String countryCode) async {
    Map<String, dynamic> body = {
      "username": name,
      "password": password,
      "name": name,
      "phone": phone,
      "gender": gender.toLowerCase(),
      "is_active": false,
      "role": 1,
      'country_code': countryCode,
      'user_language': _storageController.get('language') ?? 'en',
    };
    try {
      LocalUser? user = await _provider.register(body);
      if (user != null) {
        phoneController.text = phone;
        // _storageController.set(key: "token", value: user.token!);
        otpType = "register";
        _user.user = user;
        update();
        Get.toNamed(Routes.otpVerify);
      }

    } catch (e) {
      Logger().d("Unknown error.");
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
      await updateFirebaseCreds();
    } else {
      await Get.offAllNamed(Routes.login);
    }
  }

  void phoneLogin() async {
    String? language = _storageController.get('language');
    LocalUser? res = await _provider.login(
        phone: phoneController.text,
        password: passwordController.text,
        role: LocalUser.TYPE_PATIENT,
        language: language);
    if (res != null) {
      _user.user = res;
      _storageController.set(key: "token", value: res.token!);
      isLoggedIn.value = true;
      phoneController.text = "";
      passwordController.text = "";

      try {
       await updateFirebaseCreds();
      } catch (e) {
        Logger().d("Unknown error.");
      } finally {
        update();
        Get.offAllNamed(Routes.home);
      }
    }
  }

  void loginWithBiometric(String id) async {
    LocalUser? res = await _provider.loginWithBioID(id: id);
    if (res != null) {
      _user.user = res;
      _storageController.set(key: "token", value: res.token!);
      isLoggedIn.value = true;
      try {
        final userCredential = await FirebaseAuth.instance.signInAnonymously();
        String? apnToken;
        if (Platform.isIOS) {
          apnToken = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
        }
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await _provider.updateFirebase(userCredential.user!.uid, fcmToken!,
            apnToken: apnToken);
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
    await _provider.resendOtp(phone: phoneController.text);
  }

  void verifyOtp({required String otp}) async {
    LocalUser? res = await _provider.validateOtp(
        otp, phoneController.text, otpType,
        password:
            otpType == 'forgot_password' ? newPasswordController.text : '');
    if (res != null) {
      Loaders.successDialog("Phone number verified successfully", barrierDismissible: false);
      await Future.delayed(const Duration(milliseconds: 2));
      if (otpType == "register") {
        _storageController.set(key: "token", value: res.token!);
        _user.user = res;
        update();
        await updateFirebaseCreds();
        Get.offAllNamed(Routes.home);
      }
      if (otpType == "forgot_password") {
        Get.offAllNamed(Routes.login);
      }
    }
  }

  void resetPassword() async {
    _storageController.delete(key: "token");
    if(newPasswordController.text.isEmpty ){
      Loaders.errorDialog("Please input your password".tr);
      return;
    }
    if(phoneController.text.isEmpty ){
      Loaders.errorDialog("Please input your password".tr);
      return;
    }
    bool res = await _provider.resetPassword(
        phone: phoneController.text);
    if (res) {
      otpType = "forgot_password";
      Get.toNamed(Routes.otpVerify);
    }
  }

  Future updateFirebaseCreds() async {
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      String? apnToken;
      String? apnsToken;
      if (Platform.isIOS) {
        apnToken = await FlutterCallkitIncoming.getDevicePushTokenVoIP();
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      }
      print(" ======>>>>>>>>> APN Token : $apnToken");
      // if(Platform.isAndroid){
      final fcmToken = await FirebaseMessaging.instance.getToken();
      await _provider.updateFirebase(userCredential.user!.uid, fcmToken!,
          apnToken: apnToken);
      // }
      print("============ FCM Token ===========");
      print(fcmToken);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          Logger().d("Anonymous auth hasn't been enabled for this project.");
          rethrow;
        default:
          Logger().d("Unknown error.");
          rethrow;
      }
    }
  }
}
