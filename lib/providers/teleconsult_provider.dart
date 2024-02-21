import 'dart:io';
import 'package:get/get.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/providers/base_provider.dart';

import '../controller/controllers/local_storage_controller.dart';


class TeleconsultProvider extends BaseProvider {
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  @override
  void onInit(){
    super.onInit();
    httpClient.addRequestModifier((dynamic request) {
      request.headers['language'] = _storage.get("language") ?? "";
      return request;
    });
  }

  Future<bool> uploadVisaDocuments({required String path, required String fieldName}) async{
    final form = FormData({});
    form.files.add(MapEntry("files", MultipartFile(File(path), filename: "${DateTime.now().microsecondsSinceEpoch}.${path.split('.').last}")));
    form.fields.add(const MapEntry("model_id", "6"));
    form.fields.add(MapEntry("name", fieldName));
    try{
      Response? response = await post('/query-upload-visa',form);
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

  Future getConsultationList() async{
    try{
      Response? response = await get('/consultations');
      if(response.status.hasError){
        return Future.error(response.body);
      }
      else{
        return response.body['DATA'];
      }
    }catch(e){
      Loaders.errorDialog(e.toString());
    }
    return null;
  }

  Future<bool> storeConsultationRequest(data) async{
    try{
      Response? response = await post('/submit-consultation', data);
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
}
