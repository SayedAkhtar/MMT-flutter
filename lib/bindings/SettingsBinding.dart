import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';

class InitialBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut(() => UserController());
  }
}