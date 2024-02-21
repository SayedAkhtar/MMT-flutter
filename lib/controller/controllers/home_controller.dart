import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/constants/home_model.dart';
import 'package:MyMedTrip/models/blog.dart';
import 'package:MyMedTrip/models/faq_model.dart';
import 'package:MyMedTrip/providers/home_provider.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  late HomeProvider _provider;
  List<Hospitals> hospitals = [];
  List<DoctorsHome> doctors = [];
  List<Faq> faqs = [];
  List<String> banners = [];
  List<Stories> stories = [];
  List blogs = [];
  var isLoading = true.obs;
  @override
  void onInit() {
    super.onInit();
    _provider = Get.put(HomeProvider());
  }



  void getHomeData() async{
    doctors= [];
    hospitals = [];
    banners = [];
    blogs =[];
    faqs = [];
    stories = [];
    Home? data = await _provider.getHomeData();
    List<Blog> blogData = await _provider.fetchBlogData();
    if(data != null){
      hospitals.addAll(data.hospitals!);
      doctors.addAll(data.doctors!);
      banners.addAll(data.banners!);
      faqs.addAll(data.faqs!);
      blogs = blogData;
      stories = data.stories!;
      isLoading.value = false;
    }
    update();
    // refresh();
  }

  void refreshFirebaseCreds() async{
    try {
      final userCredential = await FirebaseAuth.instance.signInAnonymously();
      // if(Platform.isAndroid){
        final fcmToken = await FirebaseMessaging.instance.getToken();
        await _provider.updateFirebase(userCredential.user!.uid, fcmToken!);
      // }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  void getBlogData() async{

    // update();
  }
}
