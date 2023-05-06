import 'package:get/get.dart';
import 'package:mmt_/constants/api_constants.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/models/error_model.dart';

import '../models/user_model.dart';

class UserProvider extends GetConnect {
  late String? _token;
  final Map<String, String> _headers = {};
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  @override
  void onInit() {
    httpClient.baseUrl = api_uri;
    _token = _storage.get('token');
    _headers['Authorization'] = "Bearer $_token";
    _headers['Accept'] = "application/json";
  }

  Future<User?> getUser(int id) async {
    final response = await get('user/$id');
    return response.body;
  }

  Future<Response<User>> postUser(User user) async => await post('user', user);
  Future<Response> deleteUser(int id) async => await delete('user/$id');

  Future<bool> updateUserInfo(int id, Map<String, dynamic> postBody) async{
    try {
      Response response = await put('/users/$id', postBody,
          contentType: 'application/json', headers: _headers);
      if (response.statusCode == 200) {
          return true;
      }
      if (response.statusCode! >= 400) {
        var jsonString = await response.body;
        print(jsonString);
        ErrorResponse error = ErrorResponse.fromJson(jsonString);
        Loaders.errorDialog(error.error!, title: error.message!);
        if (error.error == "Unauthenticated") {
          _storage.delete(key: "token");
        }
      }
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return false;
  }

  Future<bool> addFamily( Map<String, dynamic> postBody) async{
    try {
      Response response = await post('/family/', postBody,
          contentType: 'application/json', headers: _headers);
      if (response.statusCode! >= 200 && response.statusCode! <= 300) {
        return true;
      }
      if (response.statusCode! >= 400) {
        var jsonString = await response.body;
        print(jsonString);
        ErrorResponse error = ErrorResponse.fromJson(jsonString);
        Loaders.errorDialog(error.error!, title: error.message!);
        if (error.error == "Unauthenticated") {
          _storage.delete(key: "token");
        }
      }
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return false;
  }

  Future<List<User>> listFamilies() async{
    var _families = <User>[];
    try{
      Response response = await get('/family',
          contentType: 'application/json', headers: _headers);
      if(response.statusCode == 200){
        List jsonString = await response.body['data'];
        jsonString.forEach((element) {
          _families.add(User.fromJson(element));
        });
       return _families;
      }
      if (response.statusCode! >= 400) {
        var jsonString = await response.body;
        print(jsonString);
        ErrorResponse error = ErrorResponse.fromJson(jsonString);
        Loaders.errorDialog(error.error!, title: error.message!);
        if (error.error == "Unauthenticated") {
          _storage.delete(key: "token");
        }
      }
    }catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return _families;
  }
}
