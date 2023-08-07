import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Loaders {
  static void loadingDialog({String title="Processing", bool shouldCloseAll = true}) {
    if(Get.isDialogOpen! && shouldCloseAll){
      if(shouldCloseAll){
        Get.back(closeOverlays: true);
      }
      else{
        Get.back();
      }
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
      Get.back();
    }
    if(kDebugMode){
      Get.defaultDialog(title:title, content: Column(
        children: [
          Text(error),
          Text(StackTrace.current.toString())
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
