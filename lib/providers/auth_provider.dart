import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mmt_/constants/api_constants.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/models/error_model.dart';
import 'package:mmt_/models/user_model.dart';
import 'package:mmt_/providers/base_provider.dart';

class AuthProvider extends BaseProvider {
  final _storage = Get.find<LocalStorageController>();
  final Map<String, String> _headers = {};
  @override
  void onInit() {
    httpClient.baseUrl = api_uri;
  }

  Future<User?> register(
      String name, String password, String email, String gender) async {
    Map<String, dynamic> body = {
      "username": name,
      "password": password,
      "email": email,
      "name": name,
      "gender": gender,
      "is_active": true,
      "role": 4
    };
    // try {
      Loaders.loadingDialog();
      Response response = await post('/register', body,
          contentType: "application/json",
          headers: {'X-Requested-With': 'XMLHttpRequest'});
        if (response.statusCode == 200) {
          var jsonString = await response.body["DATA"];
          User user = User.fromJson(jsonString);
          if(Get.isDialogOpen!){
            Get.back();
          }
          return user;
        }
        if (response.statusCode! >= 400) {
          var jsonString = await response.body;
          ErrorResponse error = ErrorResponse.fromJson(jsonString);
          Get.defaultDialog(title: error.message!, content: Text(error.error!));
        }
    // } catch (error) {
    //   Get.defaultDialog(title:"Error", content: Text(error.toString()));
    //   throw const HttpException("Could not process request");
    // }
    return null;
  }

  Future<User?> login({required String phone, required String password}) async {
    Map<String, dynamic> body = {"phone": phone, "password": password};
    try {
      Loaders.loadingDialog();
      Response? response = await post("/login", body,
          contentType: "application/json",
          headers: {'X-Requested-With': 'XMLHttpRequest', 'Accept': 'application/json'});
      responseHandler(response);
      var jsonString = await response.body["DATA"];
      return User.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog("Cannot establish communication with server. Please Check your network connection.");
    } finally {}
    return null;
  }

  Future<User?> checkToken({required token}) async{
    _headers['Authorization'] = "Bearer $token";
    _headers['Accept'] = "application/json";
    _headers['X-Requested-With'] = 'XMLHttpRequest';
    try {
      Response? response = await post("/validate-token", {},
          contentType: "application/json",
          headers: _headers);
      responseHandler(response);
      var jsonString = await response.body["DATA"];
      return User.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return null;
  }

  Future<bool> logout() async{
    var token = _storage.get("token");
    if(token == null){
      return false;
    }
    Map<String, String> headers = {
      "X-Requested-With": "XMLHttpRequest",
      "Authorization": "Bearer $token"
    };
    try{
      Response res = await post('/logout','', contentType: 'application/json', headers: headers);
      if(res.status.isOk){
        _storage.delete(key: 'token');
        return true;
      }
    }catch(error){
      Loaders.errorDialog(error.toString());
    }
    return false;
  }

  Future<bool> resendOtp() async{
    var token = _storage.get("token");
    _headers['Authorization'] = "Bearer $token";
    _headers['Accept'] = "application/json";
    _headers['X-Requested-With'] = 'XMLHttpRequest';
    try {
      Response response = await post("/validate-token", {},
          contentType: "application/json",
          headers: _headers);
      if (response.statusCode == 200) {
        return true;
      }
      if (response.statusCode! < 300) {
        var jsonString = await response.body;
        ErrorResponse error = ErrorResponse.fromJson(jsonString);
        Loaders.errorDialog(error.error!, title: error.message!);
      }else{
        var jsonString = await response.body;
        ErrorResponse error = ErrorResponse.fromJson(jsonString);
        Loaders.errorDialog(error.error!, title: error.message!);
      }
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return false;
  }

  Future<bool> validateOtp(String otp, String phone) async{
    var token = _storage.get("token");
    _headers['Authorization'] = "Bearer $token";
    _headers['Accept'] = "application/json";
    _headers['X-Requested-With'] = 'XMLHttpRequest';
    try {
      Loaders.loadingDialog();
      Response? response = await post("/check-otp", {'otp': otp, 'phone': phone},
          contentType: "application/json",
          headers: _headers);
      if (response.statusCode == 200) {
        Loaders.closeLoaders();
        return true;
      }
      if (response.statusCode! < 300) {
        var jsonString = await response.body;
        ErrorResponse error = ErrorResponse.fromJson(jsonString);
        Loaders.errorDialog(error.error!, title: error.message!);
      }
      else{
        var jsonString = await response.body;
        ErrorResponse error = ErrorResponse.fromJson(jsonString);
        Loaders.errorDialog(error.error!, title: error.message!);
      }
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return false;
  }


}
