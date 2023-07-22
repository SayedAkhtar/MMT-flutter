import 'dart:io';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/doctor.dart';
import 'package:MyMedTrip/models/error_model.dart';
import 'package:MyMedTrip/providers/base_provider.dart';
import '../constants/api_constants.dart';
import '../controller/controllers/local_storage_controller.dart';

class DoctorProvider extends BaseProvider {
  final _storage = Get.find<LocalStorageController>();
  final Map<String, String> _headers = {};
  String? _token;
  @override
  void onInit() {
    httpClient.baseUrl = api_uri;
    _token = _storage.get('token');
    super.onInit();
  }

  Future<List<Doctor?>> getDoctorsByHospital(id) async{
    _headers['Authorization'] = "Bearer $_token";
    _headers['Accept'] = "application/json";
    List<Doctor?> _doctor = [];
    try{
      String uri = '/hospitals/$id/doctors';
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
    try{
      Response response = await get('/doctors/$id', contentType: 'application/json', headers: _headers);
      var jsonString = await responseHandler(response);
      return Doctor.fromJson(jsonString);
      
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
      throw const HttpException("Could not process request");
    }
    return null;
  }

  Future<List<Doctor?>> getAllDoctors({String? parameter}) async{
    List<Doctor> doctor = [];
    try{
      String uri = '/doctors';
      if(parameter != null){
        uri = "$uri${parameter}";
      }
      Response response = await get(uri, contentType: 'application/json', headers: _headers);
      var jsonString = await responseHandler(response);
      jsonString.forEach((element) => doctor.add(Doctor.fromJson(element)));
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
      throw const HttpException("Could not process request");
    }
    return doctor;
  }
}
