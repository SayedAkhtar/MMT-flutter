import 'package:MyMedTrip/helper/CustomException.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:MyMedTrip/constants/api_constants.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/models/error_model.dart';
import 'package:MyMedTrip/routes.dart';

class BaseProvider extends GetConnect implements GetxService{
  late LocalStorageController storage;
  late String? token;
  BaseProvider(){
    allowAutoSignedCert = true;
  }
  @override
  void onInit(){
    storage = Get.find<LocalStorageController>();
    token = storage.get('token');
    httpClient.baseUrl = api_uri;
    httpClient.defaultContentType = "application/json";
    httpClient.timeout = const Duration(seconds: 8);
    httpClient.addRequestModifier((dynamic request) {
      request.headers['Authorization'] = "Bearer $token";
      return request;
    });
    super.onInit();
  }

  @override void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  dynamic responseHandler(Response response) async {
    var logger = Logger();
    logger.d(token);
    switch (response.statusCode) {
      case 200:
      case 201:
      case 202:
        var responseJson;
        if(response.body['data'] != null){
          responseJson = await response.body['data'];
        }
        else if(response.body['DATA'] != null){
          responseJson = await response.body['DATA'];
        }
        else{
          throw Exception("Invalid request body");
        }

        return responseJson;
      case 300:
      case 301:
      case 302:
      case 308:
        var responseJson = await response.body['DATA'];
        print(responseJson);
        throw CustomException("Server redirection");
      case 401:
        storage.delete(key: "token");
        Get.offNamedUntil(Routes.login, (route) => false);
        String message = response.body['MESSAGE'] ?? "";
        String error = response.body['ERROR'] ?? "";
        logger.i(response.body);
        if(message.isNotEmpty && error.isNotEmpty){
          throw CustomException("$message\n$error");
        }
        throw CustomException("Login token got expired. Please login again.");
      case 403:
        throw CustomException('You are not authorized to access this resource');
      case 404:
        String message = "The resource you are trying to access in not found";
        if(response.body['MESSAGE'] != null && response.body['MESSAGE'] != ""){
          message = response.body['MESSAGE'];
        }
        else if(response.body['ERROR'] != null && response.body['ERROR'] != ""){
          message = response.body['ERROR'];
        }
        throw CustomException(message);
      case 405:
        throw CustomException("Method not allowed");
      case 400:
      case 422:
        var responseJson = response.body;
        ErrorResponse error = ErrorResponse.fromJson(responseJson);
        if(error.error!.replaceAll(RegExp('[^A-Za-z0-9]'), '').contains('Unauthenticated')){
          storage.delete(key: "token");
          Get.offNamedUntil(Routes.login, (route) => false);
          throw CustomException("Login token got expired. Please login again.");
        }
        Logger().d(error.error);
        throw Exception("${error.error}");
      case 500:
      default:
        logger.d(response.statusText);
        logger.d(response.body);
        if(Get.isDialogOpen!){
          Get.back();
        }
        throw CustomException('Server is not responding please try again later.');
    }
  }
}