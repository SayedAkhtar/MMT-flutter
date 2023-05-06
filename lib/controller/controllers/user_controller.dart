import 'package:get/get.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/models/user_model.dart';
import 'package:mmt_/providers/user_provider.dart';
import 'package:mmt_/routes.dart';

class UserController extends GetxController {
  late UserProvider _provider;
  User? user;
  List<User> familiesList = [];
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _provider = Get.put(UserProvider());
  }

  @override
  void onClose() {
    super.onClose();
    if(!_provider.isDisposed){
      _provider.dispose();
    }
  }

  void updateUser(id) async{
    Map<String, dynamic> postBody = {
      "name": user?.name,
      "dob": user?.dob,
      "phone": user?.phoneNo,
      "gender": user?.gender,
      "specialization_id": user?.speciality,
      "treatment_country": user?.treatmentCountry,
    };
    bool res = await _provider.updateUserInfo(id, postBody);
    if(res){
      Get.toNamed(Routes.home);
    }
  }

  void addFamily(userId, User family) async{
    Map<String, dynamic> postBody = {
      "name": family.name,
      "dob": family.dob,
      "phone": family.phoneNo,
      "gender": family.gender,
      "relationship": family.relationWithPatient,
      "speciality": family.speciality,
      "treatment_country": family.treatmentCountry,
      'patient_id' : userId,
    };
    bool res = await _provider.addFamily(postBody);
    if(res){
      Loaders.successDialog("Successfully added family",title:"Success");
    }
  }

  void listFamily() async{
    List<User> res = await _provider.listFamilies();
    familiesList = res;
    print(familiesList);
  }
}
