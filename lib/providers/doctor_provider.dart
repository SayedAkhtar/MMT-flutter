import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/models/doctor.dart';
import 'package:mmt_/models/error_model.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import '../constants/api_constants.dart';
import '../controller/controllers/local_storage_controller.dart';
import '../models/hospital_model.dart';

class DoctorProvider extends GetConnect {
  final _storage = Get.find<LocalStorageController>();
  final Map<String, String> _headers = {};
  String? _token;
  @override
  void onInit() {
    httpClient.baseUrl = api_uri;
    _token = _storage.get('token');
  }

  Future<List<Doctor?>> getDoctorsByHospital(id) async{
    _headers['Authorization'] = "Bearer $_token";
    _headers['Accept'] = "application/json";
    List<Doctor?> _doctor = [];
    try{
      String uri = '/hospitals/$id/doctors';
      if(httpClient.baseUrl == null){
        uri = "https://2b51-2409-40d0-8-57c9-fcc6-ca2e-fded-ecf6.in.ngrok.io/api/client/$uri";
      }
      Response response = await get(uri, contentType: 'application/json', headers: _headers);
      if (response.statusCode == 200) {
        List jsonString = await response.body["DATA"];
        jsonString.forEach((element) => _doctor.add(Doctor.fromJson(element)));
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
    return _doctor;
  }

  Future<Doctor?> getDoctorById(id) async{
    _headers['Authorization'] = "Bearer $_token";
    _headers['Accept'] = "application/json";
    try{
      Response response = await get('/doctors/$id', contentType: 'application/json', headers: _headers);
      if (response.statusCode == 200) {
        var jsonString = await response.body["data"];
        return Doctor.fromJson(jsonString);
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

  Future<List<Doctor>> getAllDoctors({String? parameter}) async{
    _headers['Authorization'] = "Bearer $_token";
    _headers['Accept'] = "application/json";
    print("======= > $_token");
    List<Doctor> _doctor = [];
    try{
      String uri = '/doctors';
      if(parameter != null){
        uri = "$uri${parameter}";
      }
      Response response = await get(uri, contentType: 'application/json', headers: _headers);
      if (response.statusCode == 200) {
        List jsonString = await response.body["data"];
        jsonString.forEach((element) => _doctor.add(Doctor.fromJson(element)));
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
    return _doctor;
  }
}
