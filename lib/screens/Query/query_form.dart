import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/constants/query_type.dart';
import 'package:MyMedTrip/models/query_response_model.dart';
import 'package:MyMedTrip/providers/query_provider.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Query/pay_page_form.dart';
import 'package:MyMedTrip/screens/Query/upload_ticket_visa_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../constants/colors.dart';
import '../../constants/query_step_name.dart';
import '../../helper/CustomSpacer.dart';
import 'doctor_reply_form.dart';
import 'document_visa_form.dart';
import 'document_visa_form_edit.dart';

class QueryForm extends StatefulWidget {
  const QueryForm(this.queryType,{super.key, this.queryId = 0, this.queryStep = QueryStep.documentForVisa});
  final int queryType;
  final int? queryId;
  final int? queryStep;
  @override
  State<QueryForm> createState() => _QueryFormState();
}

class _QueryFormState extends State<QueryForm> {
  late int currentQueryStep;
  late int nextQueryStep;
  late int queryType;
  late int nextStep;
  QueryResponse? response;
  bool paymentRequired = false;
  bool loading = false;
  bool isEditable = false;
  DateTime? currentBackPressTime;
  List<int> editableSteps = [];

  List<String> stepName = [
    "Doctor's \nReply".tr,
    "Documents For Visa".tr,
    "Payment Confirmation".tr,
    "Upload Tickets and Visa".tr
  ];

  @override
  void initState() {
    currentQueryStep = widget.queryStep!;
    queryType = widget.queryType;
    loading = true;
    fetchStepData(widget.queryId!, currentQueryStep);
    super.initState();
  }

  void fetchStepData(int queryId, int stepNo)async{
    if(widget.queryId == 0) {
      return;
    }
    QueryResponse res = await Get.put(QueryProvider()).getQueryStepData(queryId, stepNo);
    setState(() {
      response = res;
      paymentRequired = res.paymentRequired!;
      nextQueryStep = res.nextStep!;
      loading = false;
      editableSteps = res.editableSteps!;
    });
  }

  @override
  Widget build(BuildContext context) {
    // print(response!.editableSteps);
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Query Form".tr,
        showDivider: true,
        backFunction: (){
          Get.toNamed(Routes.home);
        },
      ),
      body: WillPopScope(
        onWillPop: ()async {
          DateTime now = DateTime.now();
          if (currentBackPressTime == null ||
              now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
            currentBackPressTime = now;
            Get.showSnackbar( GetSnackBar(title: "Are you sure to you want to exit ?".tr, message: "Press back button twice to close the app.".tr,duration: const Duration(milliseconds: 2),));
            return Future.value(false);
          }
          return Future.value(true);
        },
        child: SafeArea(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.all(CustomSpacer.XS),
              child: Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        (QueryType.query == queryType)
                            ? CustomStep(
                                stepName: stepName[0],
                                isActive: currentQueryStep > 1,
                                isLast: false,
                                function: () {
                                  setState(() {
                                    currentQueryStep = QueryStep.doctorResponse;
                                    isEditable = true;
                                    loading = true;
                                  });
                                  fetchStepData(widget.queryId!, QueryStep.doctorResponse);

                                })
                            : const SizedBox(),
                        CustomStep(
                            stepName: stepName[1],
                            isActive: (currentQueryStep >= QueryStep.documentForVisa) || editableSteps.contains(QueryStep.doctorResponse),
                            isLast: false,
                            function: () {
                              setState(() {
                                currentQueryStep = QueryStep.documentForVisa;
                                // isEditable = true;
                                loading = true;
                              });
                              fetchStepData(widget.queryId!, QueryStep.documentForVisa);
                              // controller
                              //     .getCurrentStepData(QueryStep.documentForVisa);
                            }),
                        paymentRequired
                            ? CustomStep(
                                stepName: stepName[2],
                                isActive: currentQueryStep >=
                                    QueryStep.payment,
                                isLast: false,
                                function: () {
                                })
                            : const SizedBox(),
                        CustomStep(
                            stepName: stepName[3],
                            isActive:
                            (currentQueryStep >= QueryStep.ticketsAndVisa) || editableSteps.contains(QueryStep.ticketsAndVisa),
                            isLast: true,
                            function: () {
                              setState(() {
                                currentQueryStep = QueryStep.ticketsAndVisa;
                                isEditable = true;
                                loading = true;
                              });
                              fetchStepData(widget.queryId!, QueryStep.ticketsAndVisa);
                            }),
                      ],
                    ),
                  ),
                  Expanded(
                    // height: MediaQuery.of(context).size.height - 120.0 - AppBar().preferredSize.height,
                    // color: Colors.greenAccent,
                    child: Container(
                      padding: const EdgeInsets.all(CustomSpacer.S),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(3, 3),
                              spreadRadius: -1,
                              blurRadius: 11,
                              color: Color.fromRGBO(0, 0, 0, 0.43),
                            )
                          ]),
                      child: Builder(
                        builder: (context){
                          if(loading){
                            return const Center(child: SizedBox(child: CircularProgressIndicator()));
                          }
                          switch (currentQueryStep) {
                            case QueryStep.doctorResponse:
                              return DoctorReplyForm(response!);
                            case QueryStep.documentForVisa:
                              if(response!.response!.isEmpty){
                                return DocumentForVisaForm(response!);
                              }
                              return EditDocumentForVisaForm(response!);
                            case QueryStep.payment:
                              return PayPageForm(response!);
                            case QueryStep.ticketsAndVisa:
                              return UploadTicketAndVisaForm(response!);
                            default:
                              return const SizedBox();
                          }

                          return const SizedBox();
                        },
                      ),
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }

  List<Step> getSteps(context) {
    return [];
  }
}

class CustomStep extends StatelessWidget {
  final String stepName;
  final bool isActive;
  final bool isLast;
  VoidCallback function;
  CustomStep(
      {super.key,
      required this.stepName,
      required this.isActive,
      required this.function,
      required this.isLast});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: function,
      child: SizedBox(
        height: 110,
        width: !isLast ? 130 : 90,
        child: Stack(
          children: [
            SizedBox(
              width: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: isActive
                          ? MYcolors.bluecolor
                          : MYcolors.greylightcolor,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      Icons.medical_services_outlined,
                      color: isActive ? Colors.white : Colors.white,
                    ),
                  ),
                  Flexible(
                      child: Text(
                    stepName,
                    maxLines: 2,
                    overflow: TextOverflow.fade,
                    textAlign: TextAlign.center,
                  ))
                ],
              ),
            ),
            !isLast
                ? Positioned(
                    right: 0,
                    top: 25,
                    child: SizedBox(
                      width: 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                                color: MYcolors.greylightcolor,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                                color: MYcolors.greylightcolor,
                                borderRadius: BorderRadius.circular(100)),
                          ),
                          Container(
                            height: 6,
                            width: 6,
                            decoration: BoxDecoration(
                                color: MYcolors.greylightcolor,
                                borderRadius: BorderRadius.circular(100)),
                          )
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
