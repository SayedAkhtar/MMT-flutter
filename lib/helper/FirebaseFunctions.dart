import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseFunctions {
  static Future<String?> uploadImage(File? imageFile) async {
    if (imageFile == null) return null;

    try {
      final storage = FirebaseStorage.instance;
      String ext = imageFile.path.split('.').last;
      final Reference ref =
          storage.ref().child('query_docs/${DateTime.now()}.${ext}');
      final UploadTask uploadTask = ref.putFile(imageFile);
      Get.defaultDialog(
          title: "Uploading",
          content: StreamBuilder(
            stream: uploadTask.snapshotEvents,
            builder:
                (BuildContext context, AsyncSnapshot<TaskSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.connectionState == ConnectionState.active ||
                  snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return const Text('Error');
                } else if (snapshot.hasData) {
                  return Text(
                      "${((snapshot.data!.bytesTransferred / snapshot.data!.totalBytes) * 100).toInt()} %",
                      style:
                          const TextStyle(color: Colors.white10, fontSize: 24));
                } else {
                  return const Text('Empty data');
                }
              } else {
                return Text('State: ${snapshot.connectionState}');
              }
            },
          ));
      await uploadTask.whenComplete(() => print('Image uploaded'));

      final imageUrl = await ref.getDownloadURL();
      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
      return imageUrl;
    } catch (e) {
      print('Error uploading image: $e');
    } finally {
      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
    }
    return null;
  }

  static Future<List<String>?> uploadMultipleFiles(List<File?> files) async {
    try {
      final storage = FirebaseStorage.instance;
      Get.defaultDialog(
          title: "Uploading",
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
      print('Error uploading image: $e');
    } finally {
      if (Get.isDialogOpen != null && Get.isDialogOpen!) {
        Get.back();
      }
    }
    return null;
  }
}
