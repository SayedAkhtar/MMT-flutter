import 'package:get/get.dart';
import 'package:mmt_/constants/api_constants.dart';
import 'package:mmt_/constants/home_model.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/models/blog.dart';
import 'package:mmt_/providers/base_provider.dart';

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
}
