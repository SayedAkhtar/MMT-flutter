import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/constants/home_model.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/blog.dart';
import 'package:MyMedTrip/providers/base_provider.dart';
import 'package:logger/logger.dart';

class HomeProvider extends BaseProvider {
  late String? _token;
  final Map<String, String> _headers = {};
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  @override
  void onInit() {
    super.onInit();
    httpClient.addRequestModifier((dynamic request) {
      request.headers['language'] = _storage.get("language") ?? "";
      return request;
    });
  }

  Future<Home?> getHomeData() async{
    try{
      Response response = await get('/home');
      var body = await responseHandler(response);
      Home data = Home.fromJson(body);
      return data;
    } catch (error) {
      Loaders.errorDialog("$error", title: "Error");
      printError(info: error.toString());
    }
    return null;
  }
  
  Future<dynamic> fetchBlogData({int page = 1}) async{
    List<Blog> blogs= [];
    try{
      Response res = await GetConnect(allowAutoSignedCert: true).get('https://mymedtrip.com/wp-json/wp/v2/posts?page=$page');
      if(res.status.code == 200){
        print(res.headers);
        List<dynamic> json = res.body;
        for (var element in json) {
          blogs.add(Blog.fromJson(element));
        }
      }
    }catch(e){
      print(e.toString());
      Logger().e(e.toString());
    }
    return blogs;
  }

  Future<bool> updateFirebase(String uid, String fcm) async{
    try {
      Loaders.loadingDialog();
      Response? response = await post("/update-firebase", {'uid': uid, 'token': fcm},
        contentType: "application/json",);
      var jsonString = await responseHandler(response);
    } catch (error) {
      Loaders.errorDialog(error.toString());
    } finally {}
    return false;
  }

  Future<bool> disconnectCall(String uid, String? userId) async {
    try{
      Response? response = await post("/decline-call", {'uid': uid, 'user_id': userId},
        contentType: "application/json",);
      var jsonString = await responseHandler(response);
      return true;
    }catch(error){
      FirebaseCrashlytics.instance.log(error.toString());
    }
    return false;
  }
}
