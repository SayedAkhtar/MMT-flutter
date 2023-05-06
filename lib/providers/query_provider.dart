import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mmt_/constants/api_constants.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/models/confirmed_query.dart';
import 'package:mmt_/models/query_screen_model.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import 'package:mmt_/routes.dart';

import '../controller/controllers/local_storage_controller.dart';
import '../models/error_model.dart';

class QueryProvider extends GetConnect {
  late String? _token;
  final Map<String, String> _headers = {};
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  @override
  void onInit() {
    httpClient.baseUrl = api_uri;
    _token = _storage.get('token');
    _headers['Authorization'] = "Bearer $_token";
    _headers['Accept'] = "application/json";
  }

  Future<QueryScreen?> getQueryScreenData() async {
    try {
      Response response = await get('/queries',
          contentType: 'application/json', headers: _headers);
      if (response.statusCode == 200) {
        var jsonString = await response.body["DATA"];
        QueryScreen data = QueryScreen.fromJson(jsonString);
        return data;
      }
      if (response.statusCode! >= 400) {
        var jsonString = await response.body;
        ErrorResponse error = ErrorResponse.fromJson(jsonString);
        Loaders.errorDialog(error.error!, title: error.message!);
        if (error.error == "Unauthenticated") {
          _storage.delete(key: "token");
        }
      }
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return null;
  }

  Future<bool> postQueryGenerationData(FormData data) async {

    // try{
      Loaders.loadingDialog(title: "Uploading Data");
      Response response = await post('/queries', data, headers: _headers);
      print(response.body);
      if(response.isOk){
        return true;
      }else{
        var jsonString = response.body;
        if( jsonString is Map<String, dynamic>){
          ErrorResponse error= ErrorResponse.fromJson(jsonString);
          Loaders.errorDialog(error.error!, title: error.message!);
        }
        printError(info: "postQueryGenerationData response body is null");
         throw Exception("postQueryGenerationData response body is null");
      }
    // }catch(e){
    //   Loaders.errorDialog(e.toString());
    // }
    return false;
  }

  Future getConfirmedQueryDetail() async{
    // try {
    //   Response response = await get('/confirmed-query',
    //       contentType: 'application/json', headers: _headers);
    //   if (response.isOk) {
    //     var jsonString = await response.body["DATA"];
    //     ConfirmedQuery data = ConfirmedQuery.fromJson(jsonString);
    //     return data;
    //   }
    //   if (response.hasError) {
    //     var jsonString = await response.body;
    //     ErrorResponse error = ErrorResponse.fromJson(jsonString);
    //     Loaders.errorDialog(error.error!, title: error.message!);
    //     if (error.error == "Unauthenticated") {
    //       _storage.delete(key: "token");
    //     }
    //   }
    // } catch (error) {
    //   Loaders.errorDialog(error.toString(), title: "Error");
    // }
    return null;
  }

  Future<bool> uploadVisaDocuments({required String path, required String fieldName}) async{
    final form = FormData({});
    form.files.add(MapEntry("files", MultipartFile(File(path), filename: "${DateTime.now().microsecondsSinceEpoch}.${path.split('.').last}")));
    form.fields.add(MapEntry("model_id", "6"));
    form.fields.add(MapEntry("name", fieldName));
    try{
      Response? response = await post('/query-upload-visa',form, headers: _headers);
      if(response.status.hasError){
        return Future.error(response.body);
      }
      else{
        print(response.body);
        return true;
      }
    }catch(e){
      Loaders.errorDialog(e.toString());
    }
    return false;
  }

  Future<bool> updateTransactionForUser(Map<String, dynamic> data) async{

    try{
      Response? response = await post('/update-transaction-result',data, headers: _headers);
      if(response.status.hasError){
        ErrorResponse error = ErrorResponse.fromJson(response.body);
        Loaders.errorDialog("${error.message}");
        return Future.error(response.body);
      }
      else{
        print(response.body);
        return true;
      }
    }catch(e){
      Loaders.errorDialog(e.toString());
    }
    return false;
  }

  Future<bool> updatePatientResponse(FormData data) async{
    try{
      Response response = await post('/upload-patient-response', data, headers: _headers);
      if(response.status.hasError){
        print(response.body);
        return false;
      }
      else{
        return true;
      }
    }catch(e){
      Loaders.errorDialog(e.toString());
    }
    return false;
  }

}