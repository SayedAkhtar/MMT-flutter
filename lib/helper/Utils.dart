import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mmt_/constants/api_constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

class Utils {
  static void checkResponseVariableType(Map<String, dynamic> json){
    json.forEach((key, value) {
      print( "$key : ${value.runtimeType}");
    });
  }

  static String absoluteUri(uri){
    bool isAbsolute = Uri.tryParse(uri)?.hasAbsolutePath ?? false;
    return isAbsolute ? uri : '$base_uri/$uri';
  }

  static Image networkImageWithLoader(imageUri){
    return Image.network(
      imageUri,
      fit: BoxFit.fill,
      height: 100,
      width: 180,
      loadingBuilder: (BuildContext context, Widget child,
          ImageChunkEvent? loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }

  static String getMonthShortName(int month){
    switch(month){
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return 'Wrong Month';
    }
  }

  static String formatDate(DateTime date){
    return DateFormat('yyyy-MM-dd').format(date);
  }
  static String formatDateWithTime(DateTime date){
    return DateFormat('yyyy-MM-dd hh:mm a').format(date);
  }

  static Future<File?> saveFileToDevice(String filename, String url) async {
    HttpClient client = HttpClient();
    try{
      if(await Permission.storage.request().isGranted){
        var request = await client.getUrl(Uri.parse(url));
        var response = await request.close();
        print(response);
        var bytes = await consolidateHttpClientResponseBytes(response);
        String dir = '/storage/emulated/0/Download';
        if(Platform.isIOS){
          Directory? downloadsDir = await getTemporaryDirectory();
            dir = downloadsDir.path;
        }
        print(dir);
        if(dir != null){
          File file = new File('$dir/$filename');
          print(file);
          await file.writeAsBytes(bytes);
          return file;
        }
      }else{
        Get.snackbar("Error","File save permissions denied" );
        // Loaders.errorDialog("File save permissions denined");
        print("Permissions not granted");
      }

    }catch(ex){
      Get.snackbar("Error",ex.toString() );
      print(ex);
    }
    return null;
//     var status = await Permission.storage.status;
//     if (!status.isGranted) {
//       await Permission.storage.request();
//     }
//
//     var dir = Platform.isAndroid
//         ? '/storage/emulated/0/Download'
//         : await FilePicker.platform.getDirectoryPath();
//
// // Create the file and write the data to it
//     var file = File('$dir/$filename');
//
//     bool alreadyDownloaded = await file.exists();
//
//     await file.writeAsBytes(data, flush: true);
//
//     return 'file://${file.path}';
  }
}