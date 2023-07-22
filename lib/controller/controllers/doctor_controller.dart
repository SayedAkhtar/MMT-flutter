import 'package:get/get.dart';
import 'package:MyMedTrip/locale/AppTranslation.dart';
import 'package:MyMedTrip/models/doctor.dart';
import 'package:MyMedTrip/models/hospital_model.dart';
import 'package:MyMedTrip/providers/doctor_provider.dart';
import 'package:MyMedTrip/providers/hospital_provider.dart';
import 'package:MyMedTrip/routes.dart';

class DoctorController extends GetxController {
  late DoctorProvider _provider;
  Doctor? selectedDoctor;
  RxBool gettingDetail = true.obs;

  RxList<Doctor> doctors = <Doctor>[].obs;

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
    if(arguments.containsKey('hospital_id') && arguments['hospital_id'] != ''){
      res = await _provider.getDoctorsByHospital(arguments['hospital_id']);
    }
    if(arguments.containsKey('type') && arguments['type'] == 'allDoctor'){
      res = await _provider.getAllDoctors();
    }
    return res;
  }

  void getDoctorById(id) async{
    gettingDetail.value = true;
    Doctor? res = await _provider.getDoctorById(id);
    if(res != null){
      selectedDoctor = res;
      gettingDetail.value = false;
    }
  }

  void openDoctorsDetailsPage(id) async{
    Doctor? res = await _provider.getDoctorById(id);
    if(res != null){
      selectedDoctor = res;
      update();
      Get.toNamed(Routes.doctorPreview);
    }
  }

  void doctorSearchPage({String? parameter}) async{
    List<Doctor?> doctors = await _provider.getAllDoctors();
    if(doctors.isNotEmpty){
      for (var element in doctors) {
        doctors.add(element!);
      }
    }

  }

  // Future<List<Doctor>>
}
