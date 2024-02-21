
import 'dart:io';

import 'package:get/get.dart';
import 'package:MyMedTrip/constants/api_constants.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/user_model.dart';
import 'package:MyMedTrip/providers/base_provider.dart';

class AuthProvider extends BaseProvider {
  final _storage = Get.find<LocalStorageController>();
  final Map<String, String> _headers = {};
  @override
  void onInit() {
    httpClient.baseUrl = api_uri;
    allowAutoSignedCert = true;
    super.onInit();
  }

  Future<LocalUser?> register(Map<String, dynamic> body) async {
    try {
      Loaders.loadingDialog();
      Response response = await post('/register', body,
          contentType: "application/json",
          headers: {'X-Requested-With': 'XMLHttpRequest'});
      var jsonString = await responseHandler(response);
      LocalUser user = LocalUser.fromJson(jsonString);
      return user;
    } catch (error) {
      Loaders.errorDialog(error.toString());
      // Get.defaultDialog(title: "Error", content: Text(error.toString()));
    }
    return null;
  }

  Future<LocalUser?> login(
      {required String phone,
      required String password,
      required int role,
      String? language}) async {
    Map<String, dynamic> body = {
      "phone": phone,
      "password": password,
      "language": language,
      "role": role
    };
    try {
      Loaders.loadingDialog();
      Response? response = await post("/login", body,
          contentType: "application/json",
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
          });
      
      var jsonString = await responseHandler(response);
      return LocalUser.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return null;
  }

  Future<LocalUser?> checkToken({required token}) async {
    _headers['Authorization'] = "Bearer $token";
    _headers['Accept'] = "application/json";
    _headers['X-Requested-With'] = 'XMLHttpRequest';
    try {
      Response? response = await post("/validate-token", {},
          contentType: "application/json", headers: _headers);
      var jsonString = await responseHandler(response);
      return LocalUser.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return null;
  }

  Future<bool> logout() async {
    try {
      Response res = await post('/logout', '', contentType: 'application/json');
      storage.delete(key: "token");
      // await responseHandler(res);
      return true;
    } catch (error) {
      Loaders.errorDialog(error.toString());
    }
    return false;
  }

  Future<bool> resendOtp({required String phone}) async {
    try {
      Response response = await post("/resend-otp", {
        "phone": phone
      },
          contentType: "application/json");
      var jsonString = await responseHandler(response);
      return true;
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return false;
  }

  Future<LocalUser?> validateOtp(String otp, String phone, String type, {String? password }) async {
    try {
      // Loaders.loadingDialog();
      Response? response = await post(
          "/check-otp", {'otp': otp, 'phone': phone, 'type': type, 'password': password});
      var jsonString = await responseHandler(response);
      return LocalUser.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return null;
  }

  Future<bool> updateFirebase(String uid, String fcm, {String? apnToken}) async {
    token = _storage.get("token");
    try {
      // Loaders.loadingDialog();
      Response? response = await post(
        "/update-firebase",
        {'uid': uid, 'token': fcm, 'voip_apn_token': apnToken, 'device_type': Platform.isIOS ? 'ios' : 'android'},
        contentType: "application/json",
      );
      await responseHandler(response);
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return false;
  }

  Future<LocalUser?> loginWithBioID({required String id}) async {
    Map<String, dynamic> body = {"local_auth": id};
    try {
      Loaders.loadingDialog();
      Response? response = await post("/login-with-bio", body,
          contentType: "application/json",
          headers: {
            'X-Requested-With': 'XMLHttpRequest',
            'Accept': 'application/json'
          });
      await responseHandler(response);
      var jsonString = await response.body["DATA"];
      return LocalUser.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return null;
  }

  Future<bool> resetPassword(
      {required String phone}) async {
    Map<String, dynamic> body = {
      "phone": phone
    };
    try {
      Response? response = await post("/forgot-password", body);
      var jsonString = await responseHandler(response);
      return true;
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return false;
  }
}
