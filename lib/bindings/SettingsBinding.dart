import 'package:get/get.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';

class InitialBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}