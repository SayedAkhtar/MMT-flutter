import 'package:get/get.dart';
import '../controller/controllers/teleconsult_controller.dart';

class ConsultationBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<TeleconsultController>(() => TeleconsultController());
  }
}