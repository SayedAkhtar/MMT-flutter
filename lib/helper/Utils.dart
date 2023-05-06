import 'package:flutter/material.dart';
import 'package:mmt_/constants/api_constants.dart';

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
}