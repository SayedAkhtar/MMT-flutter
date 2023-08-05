import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:MyMedTrip/helper/Loaders.dart';

class FirebaseFunctions {
  static Future<String?> uploadImage(File? imageFile, {String? ref, String? title} ) async {
    if (imageFile == null) return null;
    String _ref = ref ?? 'query_docs';
    try {
      final storage = FirebaseStorage.instance;
      String ext = imageFile.path.split('.').last;
      final Reference ref =
          storage.ref().child('$_ref/${DateTime.now()}.${ext}');
      Get.defaultDialog(
          title: title??"Uploading",
          content: const CircularProgressIndicator());
      final UploadTask uploadTask = ref.putFile(imageFile);
      await uploadTask.whenComplete(() => print('Image uploaded'));

      final imageUrl = await ref.getDownloadURL();
      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
      return imageUrl;
    } catch (e) {
      Loaders.errorDialog("Image not uploaded. Please try again.", title: "Opps!!");
      print('Error uploading image: $e');
    } finally {
      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
    }
    return null;
  }

  static Future<List<String>?> uploadMultipleFiles(List<File?> files, {String? ref, String? title}) async {
    try {
      final storage = FirebaseStorage.instance;
      Get.defaultDialog(
          title: title ?? "Uploading",
          content: const CircularProgressIndicator());
      List<String> filePaths = [];
      for (File? file in files) {
        if (file == null) continue;
        String ext = file.path.split('.').last;
        final Reference ref =
        storage.ref().child('query_docs/${DateTime.now()}.${ext}');
        final UploadTask uploadTask = ref.putFile(file);
        await uploadTask.whenComplete(() => print('Image uploaded'));
        final imageUrl = await ref.getDownloadURL();
        filePaths.add(imageUrl);
        print(imageUrl);
      }

      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
      return filePaths;
    } catch (e) {
      Loaders.errorDialog("Image not uploaded. Please try again.", title: "Opps!!");
      print('Error uploading image: $e');
    } finally {
      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
    }
    return null;
  }
}
