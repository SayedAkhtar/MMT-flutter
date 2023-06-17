import 'dart:io';

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
  @override
  void onInit() {
    httpClient.baseUrl = api_uri;
    _token = _storage.get('token');
    super.onInit();
  }

  Future<Hospital?> getHospitalById(id) async {
    try {
      String uri = '/hospitals/$id';
      Response response = await get(uri, contentType: 'application/json');
      var jsonString = await responseHandler(response);
      return Hospital.fromJson(jsonString);
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
      throw const HttpException("Could not process request");
    }
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
  // Future<Result> ajaxSearch(term) async{
  //
  // }
}
