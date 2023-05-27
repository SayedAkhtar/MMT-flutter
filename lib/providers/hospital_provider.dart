import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/models/error_model.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import 'package:mmt_/providers/base_provider.dart';
import '../constants/api_constants.dart';
import '../controller/controllers/local_storage_controller.dart';
import '../models/hospital_model.dart';

class HospitalProvider extends BaseProvider {
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  final Map<String, String> _headers = {};
  String? _token;
  @override
  void onInit() {
    httpClient.baseUrl = api_uri;
    _token = _storage.get('token');
    super.onInit();
  }

  Future<Hospital?> getHospitalById(id) async{
    _headers['Authorization'] = "Bearer $_token";
    _headers['Accept'] = "application/json";
    try{
      if(id== null || id == ''){
        return null;
      }
      String uri = '/hospitals/$id';
      Response response = await get(uri, contentType: 'application/json', headers: _headers);
      if(response == null){
        Loaders.responseNull();
      }
      if (response.statusCode == 200) {
        var jsonString = await response.body["DATA"];
        Hospital data = Hospital.fromJson(jsonString);
        return data;
      }
      if (response.statusCode! >= 400) {
        var jsonString = await response.body;
        ErrorResponse error = ErrorResponse.fromJson(jsonString);
        Loaders.errorDialog(error.error!, title: error.message!);
        if(error.error == "Unauthenticated"){
          _storage.delete(key: "token");
        }
      }
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
      throw const HttpException("Could not process request");
    }
    return null;
  }

  Future<List<Hospital?>?> getAllHospitals() async {
    List<Hospital?> hospitals= [];
    try {
      Response response = await get('/hospitals',
          contentType: 'application/json', headers: _headers);
      var jsonString = await responseHandler(response);;
      jsonString.forEach((element) {
        hospitals.add(Hospital.fromJson(element));
      });
      print(hospitals);
      return hospitals;
      // return ConfirmedQuery.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return null;
  }
  // Future<Result> ajaxSearch(term) async{
  //
  // }
}
