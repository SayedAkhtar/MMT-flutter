import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:mmt_/constants/api_constants.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/models/error_model.dart';
import 'package:mmt_/routes.dart';

class BaseProvider extends GetConnect{
  late LocalStorageController storage;
  @override
  void onInit(){
    print("CAlling this");
    storage = Get.find<LocalStorageController>();
    final token = storage.get('token');
    httpClient.baseUrl = api_uri;
    print(httpClient);
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(seconds: 8);

    httpClient.addRequestModifier((request) {
      request.headers['Authorization'] = "Bearer $token";
      return request;
    });


    super.onInit();
  }

  dynamic responseHandler(Response response) async {
    var logger = Logger();

    logger.d(response.statusCode);
    logger.d(response.headers);
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        var responseJson = await response.body['DATA'];
        return responseJson;
      case 300:
      case 301:
      case 302:
      case 308:
        throw Exception("Server redirection");
      case 401:
        storage.delete(key: "token");
        Get.offNamedUntil(Routes.login, (route) => false);
        throw Exception("Login token got expired. Please login again.");
      case 403:
        throw Exception('You are not authorized to access this resource');
      case 404:
        throw Exception("The resource you are trying to access in not found");
      case 405:
        throw Exception("Method not allowed");
      case 400:
      case 422:
        var responseJson = response.body;
        ErrorResponse error = ErrorResponse.fromJson(responseJson);
        if(error.error!.replaceAll(RegExp('[^A-Za-z0-9]'), '') == 'Unauthenticated'){
          storage.delete(key: "token");
          Get.offNamedUntil(Routes.login, (route) => false);
          throw Exception("Login token got expired. Please login again.");
        }
        throw Exception("${error.error}");
      case 500:
      default:
        logger.d(response.body);
        if(Get.isDialogOpen!){
          Get.back();
        }
        throw Exception('Server is not responding please try again later.');
    }
  }
}