import 'package:get/get.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/doctor.dart';
import 'package:MyMedTrip/models/search_query_result_model.dart';
import 'package:MyMedTrip/providers/doctor_provider.dart';
import 'package:MyMedTrip/providers/teleconsult_provider.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/query_screen_model.dart';

class TeleconsultController extends GetxController {
  late TeleconsultProvider _provider;
  final DoctorProvider _doctorProvider = Get.put(DoctorProvider());
  final RxList<Result> specializations = <Result>[].obs;

  List consultationList = [];
  bool consultationsLoaded = false;

  // ----- Generate Query Page Variables ---- //
  RxInt specializationId = 0.obs;
  RxInt? doctorId = 0.obs;
  RxString preferredCountry = "India".obs;
  RxList<Doctor> doctors = <Doctor>[].obs;
  RxBool isSearchingDoctor = false.obs;
  int consultationFees = 0;
  var selectedSlot;
  int selectedConsultationDoctor = 0;

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
    if (!_provider.isDisposed) {
      _provider.dispose();
    }
  }

  void getDoctors({int? page}) async {
    isSearchingDoctor.value = true;
    List<Doctor> _doctors = [];
    var res = await _doctorProvider.getAllDoctors(
        parameter: "?specialization_id=${specializationId.value}&video_consultation=true&page=${page??0}");
    for (var element in res) {
      if (element != null) {
        _doctors.add(element);
      }
    }
    doctors.value = _doctors;
    isSearchingDoctor.value = false;
    doctors.refresh();
  }

  void getPopularDoctors({int? page}) async {
    isSearchingDoctor.value = true;
    List<Doctor> _doctors = [];
    var res = await _doctorProvider.getAllDoctors(
        parameter: "?popular=true&video_consultation=true&page=${page??0}");
    for (var element in res) {
      if (element != null) {
        _doctors.add(element);
      }
    }
    doctors.value = _doctors;
    isSearchingDoctor.value = false;
    doctors.refresh();
  }

  void confirmAppointmentSlot(DoctorTimeSlot slot, int price, int doctorId) {
    selectedSlot = slot;
    consultationFees = price;
    selectedConsultationDoctor = doctorId;
    update();
    Get.toNamed(Routes.teleconsultationPay);
  }

  void getAllConsultations() async {
    List res = await _provider.getConsultationList();
    consultationList = res;
    consultationsLoaded = true;
    update();
  }

  void handleSuccesfulPaymentResponse(PaymentSuccessResponse response) async {
    var data = {
      'doctor_id': selectedConsultationDoctor,
      "scheduled_at": selectedSlot.timestamp,
      'r_payment_id': response.paymentId,
      'response': {
        'orderID': response.orderId,
        'signatureId': response.signature
      }.toString(),
      'amount': 190,
    };
    Loaders.loadingDialog();
    bool created = await _provider.storeConsultationRequest(data);
    Get.toNamed(Routes.teleconsultationConfirm);
  }
}
