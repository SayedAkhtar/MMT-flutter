import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mmt_/constants/api_constants.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/models/confirmed_query.dart';
import 'package:mmt_/models/doctor.dart';
import 'package:mmt_/models/query_screen_model.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import 'package:mmt_/providers/base_provider.dart';
import 'package:mmt_/providers/doctor_provider.dart';
import 'package:mmt_/routes.dart';

import '../controller/controllers/local_storage_controller.dart';
import '../models/error_model.dart';

class TeleconsultProvider extends BaseProvider {


  Future<bool> uploadVisaDocuments({required String path, required String fieldName}) async{
    final form = FormData({});
    form.files.add(MapEntry("files", MultipartFile(File(path), filename: "${DateTime.now().microsecondsSinceEpoch}.${path.split('.').last}")));
    form.fields.add(MapEntry("model_id", "6"));
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
}
