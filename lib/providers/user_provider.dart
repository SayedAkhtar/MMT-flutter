import 'package:MyMedTrip/models/user_family_model.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/error_model.dart';
import 'package:MyMedTrip/providers/base_provider.dart';
import 'package:logger/logger.dart';

import '../models/user_model.dart';

class UserProvider extends BaseProvider {
  late String? _token;
  late Map<String, String> _headers;
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  @override
  void onInit() {
    this.token = _storage.get('token');
    super.onInit();
  }


  Future<LocalUser?> getUser(int id) async {
    final response = await get('/users/$id');
    var jsonBody = await responseHandler(response);
    print(jsonBody);
    return LocalUser.fromJson(jsonBody);
  }

  Future<Response<LocalUser>> postUser(LocalUser user) async =>
      await post('user', user);

  Future<Response> deleteUser(int id) async => await delete('user/$id');

  Future<LocalUser?> updateUserInfo(
      int id, Map<String, dynamic> postBody) async {
    Logger().d(postBody);
    try {
      Response response =
          await post('/users/$id', postBody, contentType: 'application/json');
      var jsonBody = await responseHandler(response);
      return LocalUser.fromJson(jsonBody);
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return null;
  }

  Future updateUserAvatar(int id, FormData postBody) async {
    token = _storage.get("token");
    Response response = await post('/update-avatar/$id', postBody);
    var jsonResponse = await responseHandler(response);
    return jsonResponse;
  }

  Future<bool> addFamily(Map<String, dynamic> postBody) async {
    token = _storage.get("token");
    try {
      Response response = await post('/family', postBody);
      var jsonString = await responseHandler(response);
      Logger().i(jsonString);
      return true;
    } catch (error, stack) {
      Loaders.errorDialog(error.toString(), title: "Error", stackTrace: stack);
    }
    return false;
  }

  Future<List<UserFamily>> listFamilies() async {
    token = _storage.get("token");
    var families = <UserFamily>[];
    try {
      Response response = await get('/family');
      List jsonString = await responseHandler(response);
      for (var item in jsonString) {
        families.add(UserFamily.fromJson(item));
      }
      return families;
    } catch (error, stack) {
      Loaders.errorDialog(error.toString(), title: "Error", stackTrace: stack);
    }
    return families;
  }

  Future<bool> deleteFamilyMember(int id) async{
    try {
      Response response = await delete('/family/$id');
      var jsonString = await responseHandler(response);
      return true;
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return false;
  }

  Future updateUserPassword(
      {required String oldPassword,
      required String newPassword,
      required String confirmPassword, required LocalUser user}) async {
    Map<String, dynamic> data = {
      'old_password': oldPassword,
      'password': newPassword,
      'password_confirmation': confirmPassword,
    };
    try {
      Response response = await post('/users/${user.id}', data);
      var jsonString = await responseHandler(response);
      return true;
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return false;
  }

  Future<bool> updateUserLanguage({required language}) async{
    try {
      // Response response = await post('/update-language', {'language': language});
      // var jsonString = await responseHandler(response);
      return true;
    } catch (error) {
      Loaders.errorDialog(error.toString(), title: "Error");
    }
    return false;
  }
}
