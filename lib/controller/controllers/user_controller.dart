import 'dart:io';

import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:MyMedTrip/helper/FirebaseFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/helper/Utils.dart';
import 'package:MyMedTrip/models/user_model.dart';
import 'package:MyMedTrip/providers/user_provider.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:logger/logger.dart';

import '../../models/user_family_model.dart';

class UserController extends GetxController {
  late UserProvider _provider;
  LocalUser? user;
  List<UserFamily> familiesList = [];
  RxBool loading = true.obs;
  RxBool familiesLoading = false.obs;

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
    oldPasswordController.dispose();
    passwordController.dispose();
  }

  void updateUser(id) async {
    Map<String, dynamic> postBody = {
      "name": user?.name,
      "dob": Utils.formatDate(user?.dob).toString(),
      "phone": user?.phoneNo,
      "gender": user?.gender,
      "specialization_id": user?.speciality,
      "country": user?.treatmentCountry,
    };
    Loaders.loadingDialog();
    LocalUser? res = await _provider.updateUserInfo(id, postBody);
    if (res != null) {
      user = res;
      update();
      Future.delayed(
          const Duration(seconds: 1), () => Get.toNamed(Routes.home));
    }
  }

  void updateProfileImage(id, path) async {
    String? imgPath =
        await FirebaseFunctions.uploadImage(File(path), ref: 'user_avatar');
    if (imgPath == null) {
      return;
    }
    FormData form = FormData({});
    form.fields.add(MapEntry("avatar", imgPath));
    form.fields.add(MapEntry("gender", user!.gender!));
    var res = await _provider.updateUserAvatar(id, form);
    user!.image = res['avatar'];
    update();
  }

  void addFamily(userId, UserFamily family) async {
    Map<String, dynamic> postBody = family.toJson();
    print(postBody);
    Loaders.loadingDialog();
    bool res = await _provider.addFamily(postBody);
    if (res) {
      Loaders.successDialog("Successfully added family", title: "Success");
      Get.offNamed(Routes.addFamily);
      Get.toNamed(Routes.listFamily);
    }
  }

  void listFamily() async {
    List<UserFamily> res = await _provider.listFamilies();
    familiesList = res;
    loading.value = false;
    update();
  }

  void deleteFamily(id) async {
    loading.value = true;
    Loaders.loadingDialog();
    bool res = await _provider.deleteFamilyMember(id);
    if(res){
      List<UserFamily> _newList = [];
      familiesList.forEach((element) {
        if(element.id != id){
          _newList.add(element);
        }
      });
      familiesList = _newList;
    }
    Get.back();
    update();
  }

  void updatePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    Loaders.loadingDialog();
    bool res = await _provider.updateUserPassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword);
    if(res){
      AuthController authController = Get.find<AuthController>();
      authController.logout();
    }

  }

  void updateBiometric(id, gender, value) async {
    Map<String, dynamic> postBody = {
      "local_auth": value,
      "gender": gender,
    };
    LocalUser? res = await _provider.updateUserInfo(id, postBody);
    if (res != null) {
      user = res;
    }
    update();
  }

  void updateUserInfo(id) async{
    LocalUser? res = await _provider.getUser(id);
    if(res != null){
      user = res;
    }
    update();
  }

}
