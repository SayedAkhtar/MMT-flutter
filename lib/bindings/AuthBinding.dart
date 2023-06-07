import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/auth_controller.dart';

class AuthBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}