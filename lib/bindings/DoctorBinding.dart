import 'package:get/get.dart';
import 'package:mmt_/controller/controllers/auth_controller.dart';
import 'package:mmt_/controller/controllers/doctor_controller.dart';
import 'package:mmt_/controller/controllers/hospital_controller.dart';

class DoctorBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DoctorController>(() => DoctorController());
  }
}