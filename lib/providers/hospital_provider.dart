import 'dart:io';

import 'package:MyMedTrip/models/treatment.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/error_model.dart';
import 'package:MyMedTrip/models/search_query_result_model.dart';
import 'package:MyMedTrip/providers/base_provider.dart';
import '../constants/api_constants.dart';
import '../controller/controllers/local_storage_controller.dart';
import '../models/hospital_model.dart';

class HospitalProvider extends BaseProvider {
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  final Map<String, String> _headers = {};
  String? _token;

  Future<Hospital?> getHospitalById(id) async {
    try {
      String uri = '/hospitals/$id';
      print("object");
      Response response = await get(uri, contentType: 'application/json');
      print(response.statusCode);
      var jsonString = await responseHandler(response);
      return Hospital.fromJson(jsonString);
    } catch (error) {
      print(error.toString());
      // Loaders.errorDialog(error.toString(), title: "Error");
    }
    return null;
  }

  Future<List<Hospital?>?> getAllHospitals() async {
    List<Hospital?> hospitals = [];
    try {
      Response response = await get('/hospitals',
          contentType: 'application/json', headers: _headers);
      var jsonString = await responseHandler(response);
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
  Future<List<Treatment?>> getAllTreatments() async {
    List<Treatment?> treatment = [];
    try {
      Response response = await get('/treatments',
          contentType: 'application/json');
      var jsonString = await responseHandler(response);
      jsonString.forEach((element) {
        treatment.add(Treatment.fromJson(element));
      });
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return treatment;
  }
  // Future<Result> ajaxSearch(term) async{
  //
  // }
}
