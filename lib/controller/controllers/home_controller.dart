import 'package:get/get.dart';
import 'package:mmt_/constants/home_model.dart';
import 'package:mmt_/providers/home_provider.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  //TODO: Implement HomeController

  late HomeProvider _provider;
  List<Hospitals> hospitals = [];
  List<DoctorsHome> doctors = [];
  List<String> banners = [];
  var isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    _provider = Get.put(HomeProvider());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void getHomeData() async{
    Home? data = await _provider.getHomeData();
    if(data != null){
      hospitals.addAll(data.hospitals!);
      doctors.addAll(data.doctors!);
      banners.addAll(data.banners!);
      isLoading.value = true;
    }
  }

  Future getBlogData(){
    return GetConnect().get('https://mymedtrip.com/wp-json/wp/v2/posts');
  }
}
