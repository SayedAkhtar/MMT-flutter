import 'package:get/get.dart';
import 'package:MyMedTrip/models/hospital_model.dart';
import 'package:MyMedTrip/providers/hospital_provider.dart';
import 'package:MyMedTrip/routes.dart';

class HospitalController extends GetxController {
  late HospitalProvider _provider;
  int openHospitalID = 0;
  Hospital? selectedHospital;
  @override
  void onInit() {
    super.onInit();
    _provider = Get.put(HospitalProvider());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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
    var _hospital = _provider.getAllHospitals();
  }
}
