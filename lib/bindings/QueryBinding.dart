import 'package:get/get.dart';
import 'package:mmt_/controller/controllers/auth_controller.dart';
import 'package:mmt_/controller/controllers/query_controller.dart';

class QueryBinding implements Bindings{
  @override
  void dependencies() {
    Get.lazyPut<QueryController>(() => QueryController());
  }
}