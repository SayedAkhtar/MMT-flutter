import 'package:get/get.dart';
import 'package:mmt_/constants/home_model.dart';
import 'package:mmt_/models/blog.dart';
import 'package:mmt_/models/faq_model.dart';
import 'package:mmt_/providers/home_provider.dart';
import 'package:http/http.dart' as http;

class HomeController extends GetxController {
  //TODO: Implement HomeController

  late HomeProvider _provider;
  List<Hospitals> hospitals = [];
  List<DoctorsHome> doctors = [];
  List<Faq> faqs = [];
  List<String> banners = [];
  List blogs = [];
  var isLoading = true.obs;
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
    doctors= [];
    hospitals = [];
    banners = [];
    blogs =[];
    faqs = [];
    Home? data = await _provider.getHomeData();
    List<Blog> blogData = await _provider.fetchBlogData();
    if(data != null){
      hospitals.addAll(data.hospitals!);
      doctors.addAll(data.doctors!);
      banners.addAll(data.banners!);
      faqs.addAll(data.faqs!);
      blogs = blogData;
      isLoading.value = false;
    }
    update();
    // refresh();
  }


  void getBlogData() async{

    // update();
  }
}
