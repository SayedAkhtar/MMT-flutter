import 'dart:async';
import 'dart:io';

import 'package:MyMedTrip/constants/query_type.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:MyMedTrip/constants/query_step_name.dart';
import 'package:MyMedTrip/constants/razorpay_constants.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/confirmed_query.dart';
import 'package:MyMedTrip/models/generate_query_model.dart';
import 'package:MyMedTrip/models/query_response_model.dart';
import 'package:MyMedTrip/models/search_query_result_model.dart';
import 'package:MyMedTrip/providers/query_provider.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Query/query_form.dart';
import 'package:MyMedTrip/screens/Query/query_submission_success.dart';
import 'package:logger/logger.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../models/query_screen_model.dart';

class QueryController extends GetxController {
  late QueryProvider _provider;
  late QueryScreen queryScreen;
  final RxBool isLoaded = false.obs;
  bool emptyScreen = false;
  RxString specializationQueryText = "".obs;
  final RxList<Result> specializations = <Result>[].obs;
  int selectedQuery = 0;
  int selectedIndex = 0;



  RxInt currentStep = 0.obs;
  Map<String, dynamic> stepData = {};
  bool showPaymentPage = false;

  // ----- Generate Query Page Variables ---- //
  RxInt specializationId = 0.obs;
  RxInt hospitalId = 0.obs;
  RxInt doctorId = 0.obs;
  RxInt patientFaminlyId = 0.obs;
  RxString briefHistory = "".obs;
  RxString preferredCountry = "India".obs;
  String patientName = "";
  List<String> medicalVisaPath = [];
  List<String> passportPath = [];
  int queryType = 1;
  int queryFor = 1; //1 =>self | 2 => someone
  final generateQueryForm = GlobalKey<FormState>().obs;

  String doctor_response = "";

  @override
  void onInit() {
    super.onInit();
    _provider = Get.put(QueryProvider());
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

  void generateQuery() async {
    Map<String, dynamic> formData = {};
    Map<String, dynamic> responseData = {};
    formData["current_step"] = 1;
    formData["type"] = queryType;
    formData['query_for'] = queryFor;
    responseData["history"] = briefHistory.value;
    responseData["country"] = preferredCountry.value;
    responseData["medical_report"] = medicalVisaPath;
    responseData["passport"] = passportPath;

    if (patientName.isNotEmpty) {
      formData["patient_name"] = patientName;
    }
    formData['response'] = responseData;

    Logger().i(formData);
    bool res = await _provider.postQueryGenerationData(formData);
    if (res) {
      briefHistory.value = "";
      preferredCountry.value = "";
      passportPath = [];
      medicalVisaPath = [];
      patientFaminlyId.value = 0;
      Get.offNamed(Routes.startQuery);
      Get.to(QuerySubmissionSuccess());
    }
  }

  Future<void> uploadStepData(
      {required Map<String, dynamic> data,
      required int currentStep,
      required int queryType,
      required int queryId}) async {
    stepData = {};
    Map<String, dynamic> formData = {};
    formData["current_step"] = currentStep;
    formData["type"] = queryType;
    formData['response'] = data;
    formData['query_id'] = selectedQuery;
    // print(formData);
    try {
      bool res = await _provider.postQueryGenerationData(formData);
      if (res) {
        Get.offNamed(Routes.startQuery);
      }
    } catch (e) {
      Loaders.errorDialog(e.toString());
    }
  }

  void uploadVisaDocuments({required String path, required String name}) async {
    await _provider.uploadVisaDocuments(path: path, fieldName: name);
  }

  void handleSuccesfulPaymentResponse(int selectedQuery, PaymentSuccessResponse response) async {
    var data = {
      'query_id': selectedQuery,
      'r_payment_id': response.paymentId,
      'response': {
        'orderID': response.orderId,
        'signatureId': response.signature
      }.toString(),
      'amount': 15 * 100
    };
    bool res = await _provider.updateTransactionForUser(data);
    if (res) {
      Loaders.successDialog("Your payment is verified");
      Get.toNamed(Routes.activeQueryUploadTicket);
    }
  }

  //--------- Navigation with data -----------//
  void navigateToQueryForm(int id, int selectedIndex, String response) {
    doctor_response = response;
    selectedQuery = id;
    currentStep.value = 0;
    showPaymentPage =
        queryScreen.activeQuery![selectedIndex].isPaymentRequired!;
    getCurrentStepData(queryScreen.activeQuery![selectedIndex].currentStep!);
    currentStep.value = queryScreen.activeQuery![selectedIndex].currentStep!;
    queryType = queryScreen.activeQuery![selectedIndex].type!;
    this.selectedIndex = selectedIndex;
    if (queryType == 2) {
      Get.to(() => const QueryForm(QueryType.medicalVisa));
    } else {
      Get.to(() => const QueryForm(QueryType.medicalVisa));
    }

    // Get.toNamed(Routes.activeQueryDoctorReply);
  }

  void navigateToTermsPage(List<String> docPath, int currentStep) async {
    if (docPath.isEmpty) {
      Get.toNamed(Routes.activeQueryTermsConditions);
      return;
    }
    Map<String, dynamic> formData = {};
    formData['patient'] = docPath;
    formData['doctor'] = stepData['doctor'];
    // uploadStepData(formData, currentStep);
  }

  void getCurrentStepData(int step) async {
    stepData = {};
    if (selectedQuery != 0) {
      isLoaded.value = false;
      QueryResponse? data =
          await _provider.getQueryStepData(selectedQuery, step);
      if (data != null) {
        stepData = data.response!;
        showPaymentPage = data!.paymentRequired!;
      }
    }
    isLoaded.value = true;
    update();
  }
}
