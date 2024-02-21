import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/home_controller.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';

class InitialBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(LocalStorageController());
    Get.lazyPut<AuthController>(() => AuthController());
    // Get.lazyPut<UserController>(() => UserController(), fenix: true);
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