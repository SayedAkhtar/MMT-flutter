import 'package:get/get.dart';
import 'package:mmt_/locale/AppTranslation.dart';
import 'package:mmt_/models/doctor.dart';
import 'package:mmt_/models/hospital_model.dart';
import 'package:mmt_/providers/doctor_provider.dart';
import 'package:mmt_/providers/hospital_provider.dart';
import 'package:mmt_/routes.dart';

class DoctorController extends GetxController {
  late DoctorProvider _provider;
  Doctor? selectedDoctor;

  @override
  void onInit() {
    super.onInit();
    _provider = Get.put(DoctorProvider());
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

  Future<List<Doctor?>?> getDoctors({arguments}) async{
    List<Doctor?> res = [];
    if(arguments['hospital_id'] != ''){
      res = await _provider.getDoctorsByHospital(arguments['hospital_id']);
    }
    if(arguments['type'] == 'allDoctor'){
      res = await _provider.getAllDoctors();
    }
    print(res);
    return res;
  }

  void getDoctorById(id) async{
    Doctor? res = await _provider.getDoctorById(id);
    if(res != null){
      selectedDoctor = res;
    }
    update();
  }

  void openDoctorsDetailsPage(id) async{
    Doctor? res = await _provider.getDoctorById(id);
    if(res != null){
      selectedDoctor = res;
      update();
      Get.toNamed(Routes.doctorPreview);
    }
  }

  // Future<List<Doctor>>
}
