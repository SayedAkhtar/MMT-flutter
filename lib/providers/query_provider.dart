import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:MyMedTrip/constants/api_constants.dart';
import 'package:MyMedTrip/constants/query_step_name.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/confirmed_query.dart';
import 'package:MyMedTrip/models/query_response_model.dart';
import 'package:MyMedTrip/models/query_screen_model.dart';
import 'package:MyMedTrip/providers/base_provider.dart';
import 'package:logger/logger.dart';

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
    httpClient.addRequestModifier((dynamic request) {
      request.headers['language'] = _storage.get("language") ?? "";
      return request;
    });
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

  Future<bool> postQueryGenerationData(Map<String, dynamic> data) async {

    try{
      Loaders.loadingDialog(title: "Uploading Data");
      String json = jsonEncode(data);
      print(json);
      Response response = await post('/queries', data, headers: _headers, contentType: 'application/json');
      print(response.body);
      Logger().d(response.body);
      var jsonBody = await responseHandler(response);
      if(response.isOk){
        return true;
      }
    }catch(e){
      Loaders.errorDialog(e.toString());
    }
    return false;
  }

  Future<ConfirmedQuery?>? getConfirmedQueryDetail(int queryId, {String? familyId }) async{
    try {
      String getUrl = '/queries/$queryId/${QueryStep.queryConfirmed}';
      if(familyId != null && familyId != ""){
        getUrl = getUrl+'?family_id=${familyId}';
      }
      Response response = await get(getUrl,
          contentType: 'application/json', headers: _headers);
      var jsonString = await responseHandler(response);
      if(jsonString is List && jsonString.isEmpty){
        return null;
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
    form.fields.add(const MapEntry("model_id", "6"));
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
      Response response = await post('/upload-patient-response', data, headers: _headers, contentType: 'application/json');
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
    // try {
      Response response = await get('/queries/$queryId/$step',
          contentType: 'application/json', headers: _headers);
      var jsonString = await responseHandler(response);
      return QueryResponse.fromJson(jsonString);
    // } catch (error) {
    //   print(error);
    //   // Loaders.errorDialog(error.toString(), title: "Error");
    // }
  }

  Future<bool> postMedicalVisaQueryData(Map data) async {

    try{
      Loaders.loadingDialog(title: "Please Wait");
      Response response = await post('/queries', data, headers: _headers);
      print(response.body);
      responseHandler(response);
      if(response.isOk){
        Loaders.closeLoaders();
        return true;
      }
    }catch(e){
      Loaders.errorDialog(e.toString());
    }
    return false;
  }

  Future<bool> placeCall(String uuid, {String? userId, String? type}) async{
    try{
      // Loaders.loadingDialog(title: "Calling");
      Response response = await post('/trigger-support-call', {'uuid': uuid, 'user_id': userId, 'type': type ?? 'connect'}, headers: _headers);
      responseHandler(response);
      if(response.isOk){
        // Loaders.closeLoaders();
        return true;
      }
    }catch(e){
      // Loaders.errorDialog(e.toString());
    }
    return false;
  }
}
