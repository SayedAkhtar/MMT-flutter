import 'package:get/get.dart';
import 'package:MyMedTrip/constants/api_constants.dart';
import 'package:MyMedTrip/constants/home_model.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/blog.dart';
import 'package:MyMedTrip/providers/base_provider.dart';

class HomeProvider extends BaseProvider {
  late String? _token;
  final Map<String, String> _headers = {};
  final LocalStorageController _storage = Get.find<LocalStorageController>();
  @override
  void onInit() {
    super.onInit();
  }

  Future<Home?> getHomeData() async{
    try{
      Response response = await get('/home');
      var body = await responseHandler(response);
      Home data = Home.fromJson(body);
      return data;

    } catch (error) {
      Loaders.errorDialog("${error}", title: "Error");
      printError(info: error.toString());
      // throw const HttpException("Could not process request");
    }
    return null;
  }
  
  Future<dynamic> fetchBlogData() async{
    List<Blog> blogs= [];
    try{
      Response res = await GetConnect().get('https://mymedtrip.com/wp-json/wp/v2/posts');
      if(res.status.code == 200){
        List<dynamic> json = res.body;
        for (var element in json) {
          blogs.add(Blog.fromJson(element));
        }
      }
    }catch(e){
      print(e.toString());
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
}
