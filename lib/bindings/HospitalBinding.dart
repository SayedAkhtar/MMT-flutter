import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:MyMedTrip/controller/controllers/hospital_controller.dart';

class HospitalBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<HospitalController>(() => HospitalController());
  }
}