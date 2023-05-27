import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/helper/Utils.dart';
import 'package:mmt_/models/user_model.dart';
import 'package:mmt_/providers/user_provider.dart';
import 'package:mmt_/routes.dart';

class UserController extends GetxController {
  late UserProvider _provider;
  LocalUser? user;
  List<LocalUser> familiesList = [];

  final passwordController = TextEditingController();
  final oldPasswordController = TextEditingController();
  @override
  void onInit() {
    _provider = Get.put(UserProvider());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    // if(!_provider.isDisposed){
    //   _provider.dispose();
    // }
  }

  void updateUser(id) async{
    Map<String, dynamic> postBody = {
      "name": user?.name,
      "dob": Utils.formatDate(user?.dob).toString(),
      "phone": user?.phoneNo,
      "gender": user?.gender,
      "specialization_id": user?.speciality,
      "treatment_country": user?.treatmentCountry,
    };
    Loaders.loadingDialog();
    LocalUser? res = await _provider.updateUserInfo(id, postBody);
    if(res != null){
      user = res;
      update();
      // Get.showSnackbar(const GetSnackBar(title: "Profile Updated", duration: Duration(seconds: 1),));
      Future.delayed(const Duration(seconds: 1), () =>Get.toNamed(Routes.home));
    }
  }

  void updateProfileImage(id, path) async{
    var logger = Logger();
    logger.d(message)
    // FormData form = FormData({});
    // form.files.add(MapEntry("avatar", MultipartFile(File(path), filename: "${DateTime.now().microsecondsSinceEpoch}.${path.split('.').last}")));
    // form.fields.add(MapEntry("gender", user!.gender!));
    // bool res = await _provider.updateUserAvatar(id, form);
    // if(res){
    //   Get.toNamed(Routes.home);
    // }
  }

  void addFamily(userId, LocalUser family) async{
    Map<String, dynamic> postBody = {
      "name": family.name,
      "dob": Utils.formatDate(family.dob),
      "phone": family.phoneNo,
      "gender": family.gender,
      "relationship": family.relationWithPatient,
      "speciality": family.speciality,
      "treatment_country": family.treatmentCountry,
      'patient_id' : userId,
    };

    bool res = await _provider.addFamily(postBody);
    if(res){
      Loaders.successDialog("Successfully added family",title:"Success");
      Get.offNamed(Routes.addFamily);
      Get.toNamed(Routes.listFamily);
    }
  }

  void listFamily() async{
    List<LocalUser> res = await _provider.listFamilies();
    familiesList = res;
    update();
  }

  void updatePassword(id, oldPassword, newPassword) async{
    // print(oldPassword);
    // Map<String, dynamic> postBody = {
    //   "old_password": oldPassword,
    //   "password": newPassword,
    // };
    // bool res = await _provider.updateUserInfo(id, postBody);
    // if(res){
    //   Get.toNamed(Routes.home);
    // }
  }

  void updateBiometric(id,gender, value) async{
    Map<String, dynamic> postBody = {
      "local_auth": value,
      "gender": gender,
    };
    LocalUser? res = await _provider.updateUserInfo(id, postBody);
    if(res != null){
      user = res;
    }
    update();
  }
}
