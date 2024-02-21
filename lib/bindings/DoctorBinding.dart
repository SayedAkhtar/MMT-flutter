import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/doctor_controller.dart';

class DoctorBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<DoctorController>(() => DoctorController());
  }
}