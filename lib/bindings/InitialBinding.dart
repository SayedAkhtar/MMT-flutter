import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/doctor_controller.dart';
import 'package:MyMedTrip/controller/controllers/home_controller.dart';
import 'package:MyMedTrip/controller/controllers/hospital_controller.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';

class InitialBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(LocalStorageController());
    // Get.lazyPut<UserProvider>(() => UserProvider(), fenix: true);
    Get.lazyPut<UserController>(() => UserController());
    // Get.lazyPut<HomeProvider>(() => HomeProvider());
    Get.lazyPut<HomeController>(() => HomeController());
    // Get.lazyPut<QueryProvider>(() => QueryProvider());
    // Get.lazyPut<QueryController>(() => QueryController());
    // Get.lazyPut<DoctorProvider>(() => DoctorProvider());
    // Get.lazyPut<DoctorController>(() => DoctorController());
    // Get.lazyPut<HospitalProvider>(() => HospitalProvider());
    // Get.lazyPut<HospitalController>(() => HospitalController());
  }
}