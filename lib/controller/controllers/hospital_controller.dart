import 'package:get/get.dart';
import 'package:mmt_/models/hospital_model.dart';
import 'package:mmt_/providers/hospital_provider.dart';
import 'package:mmt_/routes.dart';

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
    if (!_provider.isDisposed) {
      _provider.dispose();
    }
  }

  Future<Hospital?> getHospitalById(id) async{
    openHospitalID = id;
    Hospital? res = await _provider.getHospitalById(openHospitalID);
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
