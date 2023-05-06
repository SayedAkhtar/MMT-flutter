import 'package:get/get.dart';
import 'package:mmt_/controller/controllers/doctor_controller.dart';
import 'package:mmt_/controller/controllers/home_controller.dart';
import 'package:mmt_/controller/controllers/hospital_controller.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/controller/controllers/query_controller.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';
import 'package:mmt_/providers/doctor_provider.dart';
import 'package:mmt_/providers/home_provider.dart';
import 'package:mmt_/providers/hospital_provider.dart';
import 'package:mmt_/providers/query_provider.dart';
import 'package:mmt_/providers/user_provider.dart';

class InitialBinding implements Bindings{
  @override
  void dependencies() {
    Get.put(LocalStorageController());
    Get.lazyPut<UserProvider>(() => UserProvider());
    Get.lazyPut<UserController>(() => UserController());
    Get.lazyPut<HomeProvider>(() => HomeProvider());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<QueryProvider>(() => QueryProvider());
    Get.lazyPut<QueryController>(() => QueryController());
    Get.lazyPut<DoctorProvider>(() => DoctorProvider());
    Get.lazyPut<DoctorController>(() => DoctorController());
    Get.lazyPut<HospitalProvider>(() => HospitalProvider());
    Get.lazyPut<HospitalController>(() => HospitalController());
  }
}