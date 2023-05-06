import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mmt_/models/confirmed_query.dart';
import 'package:mmt_/models/doctor.dart';
import 'package:mmt_/models/generate_query_model.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import 'package:mmt_/providers/doctor_provider.dart';
import 'package:mmt_/providers/query_provider.dart';
import 'package:mmt_/providers/teleconsult_provider.dart';
import 'package:mmt_/routes.dart';

import '../../models/query_screen_model.dart';

class TeleconsultController extends GetxController {
  late TeleconsultProvider _provider;
  final DoctorProvider _doctorProvider = Get.put(DoctorProvider());
  final RxList<Result> specializations = <Result>[].obs;

  // ----- Generate Query Page Variables ---- //
  RxInt specializationId = 0.obs;
  RxInt? doctorId =0.obs;
  RxString preferredCountry = "India".obs;
  RxList<Doctor> doctors = <Doctor>[].obs;
  RxBool isSearchingDoctor = false.obs;
  int consultationFees = 0;
  var selectedSlot;

  @override
  void onInit() {
    super.onInit();
    _provider = Get.put(TeleconsultProvider());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    if(!_provider.isDisposed){
      _provider.dispose();
    }
  }

  void getDoctors() async{
    isSearchingDoctor.value = true;
    List<Doctor> _doctors = [];
    var res = await _doctorProvider.getAllDoctors(parameter: "?specialization_id=${specializationId.value}");
    for (var element in res) {
      _doctors.add(element);
    }
    doctors.value = _doctors;
    isSearchingDoctor.value = false;
    doctors.refresh();
  }

  void confirmAppointmentSlot(DoctorTimeSlot slot, int price){
    selectedSlot = slot;
    consultationFees = price;
    print(selectedSlot.timestamp);
    update();
    Get.toNamed(Routes.teleconsultationPay);
  }

  void handleSuccesfulPaymentResponse(response) {

  }

}
