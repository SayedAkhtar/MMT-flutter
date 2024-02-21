import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';

class QueryBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<QueryController>(() => QueryController());
  }
}