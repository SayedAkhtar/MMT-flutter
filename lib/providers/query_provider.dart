import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/constants/api_constants.dart';
import 'package:MyMedTrip/constants/query_step_name.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/confirmed_query.dart';
import 'package:MyMedTrip/models/query_response_model.dart';
import 'package:MyMedTrip/models/query_screen_model.dart';
import 'package:MyMedTrip/models/search_query_result_model.dart';
import 'package:MyMedTrip/providers/base_provider.dart';
import 'package:MyMedTrip/routes.dart';

import '../controller/controllers/local_storage_controller.dart';
import '../models/error_model.dart';

class QueryProvider extends BaseProvider {
  late String? _token;
  final Map<String, String> _headers = {};
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  @override
  void onInit() {
    httpClient.baseUrl = api_uri;
    _token = _storage.get('token');
    _headers['Authorization'] = "Bearer $_token";
    _headers['Accept'] = "application/json";
    super.onInit();
  }

  Future<QueryScreen?> getQueryScreenData() async {
    try {
      Response response = await get('/queries',
          contentType: 'application/json', headers: _headers);
      var jsonString = await responseHandler(response);
      QueryScreen data = QueryScreen.fromJson(jsonString);
      return data;
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return null;
  }

  Future<bool> postQueryGenerationData(Map data) async {

    try{
      Loaders.loadingDialog(title: "Uploading Data");
      Response response = await post('/queries', data, headers: _headers);
      print(response.body);
      var jsonBody = await responseHandler(response);
      if(response.isOk){
        return true;
      }
    }catch(e){
      Loaders.errorDialog(e.toString());
    }
    return false;
  }

  Future getConfirmedQueryDetail(int queryId) async{
    try {
      Response response = await get('/queries/${queryId}/${QueryStep.queryConfirmed}',
          contentType: 'application/json', headers: _headers);
      var jsonString = await responseHandler(response);
      if(jsonString is List && jsonString.isEmpty){
        return;
      }
      return ConfirmedQuery.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
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

  Future getQueryStepData(int queryId, int step) async{
    try {
      Response response = await get('/queries/${queryId}/${step}',
          contentType: 'application/json', headers: _headers);
      var jsonString = await responseHandler(response);
      return QueryResponse.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
  }

  Future<bool> postMedicalVisaQueryData(Map data) async {

    try{
      Loaders.loadingDialog(title: "Uploading Data");
      Response response = await post('/queries', data, headers: _headers);
      print(response.body);
      responseHandler(response);
      if(response.isOk){
        return true;
      }
    }catch(e){
      Loaders.errorDialog(e.toString());
    }
    return false;
  }
}
