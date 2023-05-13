import 'dart:async';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mmt_/constants/razorpay_constants.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/models/confirmed_query.dart';
import 'package:mmt_/models/generate_query_model.dart';
import 'package:mmt_/models/search_query_result_model.dart';
import 'package:mmt_/providers/query_provider.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Query/query_submission_success.dart';
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

  // ----- Generate Query Page Variables ---- //
  RxInt specializationId = 0.obs;
  RxInt hospitalId = 0.obs;
  RxInt doctorId = 0.obs;
  RxInt patientFaminlyId = 0.obs;
  RxString briefHistory = "".obs;
  RxString preferredCountry = "India".obs;
  String medicalVisaPath = '';
  String passportPath = '';
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
    if(!_provider.isDisposed){
      _provider.dispose();
    }
  }

  void getQueryPageData() async{
    QueryScreen? res =await _provider.getQueryScreenData();
    if(res != null){
      queryScreen = res;
      isLoaded.value = true;
    }else{
      emptyScreen = true;
    }
    update();
  }

  void generateQuery() async{
    FormData _formData = FormData({});
    _formData.fields.add(MapEntry("specialization_id", specializationId.value.toString()));
    if(hospitalId.value == 0){
    }
    _formData.fields.add(MapEntry("hospital_id", hospitalId.value.toString()));
    if(doctorId.value !=0 ){
      _formData.fields.add(MapEntry("doctor_id",doctorId.value.toString()));
    }
    if(patientFaminlyId.value !=0 ){
      _formData.fields.add(MapEntry("patient_family_id",patientFaminlyId.value.toString()));
    }
    if(briefHistory.value != ""){
      _formData.fields.add(MapEntry("medical_history", briefHistory.value));
    }
    _formData.fields.add(MapEntry("preferred_country", preferredCountry.value));
    if(medicalVisaPath != ''){
      _formData.files.add(MapEntry('medical_visa', MultipartFile(File(medicalVisaPath), filename: 'medical_visa')));
    }
    if(passportPath != ''){
      _formData.files.add(MapEntry('passport_image', MultipartFile(File(passportPath), filename: 'medical_visa')));
    }
    print(_formData.fields);

    bool res = await _provider.postQueryGenerationData(_formData);
    if(res){
      Get.offNamed(Routes.startQuery);
      Get.to(QuerySubmissionSuccess());
    }
  }

  Future<ConfirmedQuery>? confirmedQuery() async{
    /** ToDo : Make it Void function **/
    return Future.delayed(Duration(seconds: 2));
    return await _provider.getConfirmedQueryDetail();
  }

  void uploadVisaDocuments({required String path, required String name}) async{
    await _provider.uploadVisaDocuments(path: path, fieldName: name);
  }

  void handleSuccesfulPaymentResponse(PaymentSuccessResponse response) async{
    var data = {
      'query_id': selectedQuery,
      'r_payment_id' : response.paymentId,
      'response': {'orderID': response.orderId, 'signatureId': response.signature}.toString(),
      'amount' : RazorpayConstants.getQueryOrderAmount()
    };
    bool res = await _provider.updateTransactionForUser(data);
    if(res){
      Loaders.successDialog("Your payment is verified");
      Get.toNamed(Routes.activeQueryUploadTicket);
    }
  }


  //--------- Navigation with data -----------//
  void navigateToDoctorsPage(int id, String response){
    doctor_response = response;
    selectedQuery = id;
    update();
    Get.toNamed(Routes.activeQueryDoctorReply);
  }

  void navigateToTermsPage(String docPath) async{
    if(docPath.isEmpty){
      Get.toNamed(Routes.activeQueryTermsConditions);
      return;
    }
    Loaders.loadingDialog();
    FormData form = new FormData({});
    form.files.add(MapEntry('document', MultipartFile(File(docPath), filename:  "${DateTime.now().microsecondsSinceEpoch}.${docPath.split('.').last}")));
    form.fields.add(MapEntry('query_id', selectedQuery.toString()));
    bool res = await _provider.updatePatientResponse(form);
    if(res){
      Get.toNamed(Routes.activeQueryTermsConditions);
    }else{
      Loaders.errorDialog("Could not upload file please try again");
    }
  }

}
