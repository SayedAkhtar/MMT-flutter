import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocalStorageController extends GetxController {
  //TODO: Implement LocalStorageController

  late GetStorage _storage;
  @override
  void onInit() {
    super.onInit();
    _storage = GetStorage();
  }

  @override
  void onReady() {
    super.onReady();
    _storage.initStorage;
  }


  String? get(key){
    if(_storage.hasData(key)){
      return _storage.read(key);
    }
    return null;
  }

  void set({required String key,required String value}) async{
    await _storage.write(key, value);
  }

  void delete({required String key}) async{
    await _storage.remove(key);
  }
}
