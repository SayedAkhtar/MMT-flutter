import 'package:get/get.dart';
import 'package:MyMedTrip/models/hospital_model.dart';
import 'package:MyMedTrip/providers/hospital_provider.dart';
import 'package:MyMedTrip/routes.dart';

class HospitalController extends GetxController {
  late HospitalProvider _provider;
  int openHospitalID = 0;
  Hospital? selectedHospital;
  RxString searchText = "".obs;
  // RxList<Hospital>? hospitals = <Hospital>[].obs;
  final hospital = Future.value(<Hospital?>[]).obs;
  @override
  void onInit() {
    super.onInit();
    _provider = Get.put(HospitalProvider());
  }



  Future<Hospital?> getHospitalById(id) async{
    // openHospitalID = id;
    Hospital? res = await _provider.getHospitalById(id);
    return res;
  }

  void openHospitalDetails(id) async{
    openHospitalID = id;
    Hospital? res = await _provider.getHospitalById(openHospitalID);
    if(res != null){
      selectedHospital = res;
      // selectedHospital
      update();
      Get.toNamed(Routes.hospitalPreview);
    }
  }

  void getAllHospitals() async{
    var hospital = _provider.getAllHospitals();
  }

  Future<List<Hospital?>?> getHospitals() async{
    List<Hospital?>? temp = await _provider.getAllHospitals(params: searchText.value);
    hospital.value = _provider.getAllHospitals(params: searchText.value);
    return temp;
  }
}
