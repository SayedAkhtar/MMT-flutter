import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loaders {
  static void loadingDialog({String title="Processing"}) {
    if(Get.isDialogOpen!){
      Get.back(closeOverlays: true);
    }
    Get.defaultDialog(
      title: title,
      content: const Center(
        child: SizedBox(
          height: 200,
          width: 200,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  static void errorDialog(String error, {String title="Error",stackTrace = ""}){
    if(Get.isDialogOpen!){
      Get.back(closeOverlays: true);
    }
    if(kDebugMode){
      Get.defaultDialog(title:"Error", content: Column(
        children: [
          Text(error),
          Text(stackTrace.toString())
        ],
      ));
    }else{
      Get.defaultDialog(title:"Error", content: Text(error));
    }
    
  }

  static void successDialog(String message, {String title="Success"}){
    if(Get.isDialogOpen!){
      Get.back(closeOverlays: true);
    }
    Get.defaultDialog(title:title, content: Text(message));
  }

  static void responseNull(){
    if(Get.isDialogOpen!){
      Get.back(closeOverlays: true);
    }
    Get.defaultDialog(title:"Opps !", content: const Text("Something went wrong.\nPlease check your network connection."));
  }

  static void closeLoaders(){
    if(Get.isDialogOpen!){
      Get.back(closeOverlays: true);
    }
  }
}
