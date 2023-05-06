import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/providers/auth_provider.dart';
import 'package:mmt_/routes.dart';

import '../../models/user_model.dart';

class AuthController extends GetxController {
  //TODO: Implement AuthController

  final registerFormKey = GlobalKey<FormState>();
  final phoneLoginFormKey = GlobalKey<FormState>();
  final emailLoginFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final gender = "male".obs;
  int loginMethod = 0;
  var isLoggedIn = false.obs;

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
  }

  int get getCurrentLoginMethod => loginMethod;

  String? validator(String? value) {
    if (value!.isEmpty) {
      return 'Please this field must be filled';
    }
    return null;
  }

  void register() async {
    if (registerFormKey.currentState!.validate()) {
      Get.toNamed(Routes.otpVerify);
      // User? user = await _provider.register(nameController.text,
      //     passwordController.text, emailController.text, gender.value);
      // if (user != null) {
      //   _storageController.set(key: "token", value: user.token!);
      //   Get.toNamed(Routes.home);
      // }
    }
  }

  void login() async {
    if (loginMethod == 0) {
      phoneLogin();
    }
  }

  // void emailLogin() async {
  //   if (emailLoginFormKey.currentState!.validate()) {
  //     User? res = await _provider.login(
  //         email: emailController.text, password: passwordController.text);
  //     if (res != null) {
  //       _user.user = res;
  //       _storageController.set(key: "token", value: res.token!);
  //       isLoggedIn.value = true;
  //       update();
  //       Get.offAllNamed(Routes.home);
  //     }
  //   }
  // }

  void validateUserToken() async {
    if (_storageController.get('token') != null ||
        _storageController.get('token') != "") {
      Loaders.loadingDialog(title: "Checking Credentials");
      User? res =
          await _provider.checkToken(token: _storageController.get('token'));
      if(res == null){
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
    if (phoneLoginFormKey.currentState!.validate()) {
      User? res = await _provider.login(
          phone: phoneController.text, password: passwordController.text);
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
  }

  void logout() async {
    if(await _provider.logout()){
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

  void resendOtp(){
    // _provider.
  }

  void verifyOtp({required String otp}) async{
    bool res = await _provider.validateOtp(otp, phoneController.text);
    if(res){
      Loaders.successDialog("Phone number verified successfully");
      Get.toNamed(Routes.home);
    }
  }
}