import 'package:MyMedTrip/constants/query_type.dart';
import 'package:MyMedTrip/models/query_response_model.dart';
import 'package:MyMedTrip/providers/query_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';

import '../../constants/colors.dart';
import '../../constants/query_step_name.dart';
import '../../helper/CustomSpacer.dart';

class QueryForm extends StatefulWidget {
  const QueryForm(this.queryType,{Key? key, this.queryId = 0, this.queryStep = QueryStep.documentForVisa}) : super(key: key);
  final int queryType;
  final int? queryId;
  final int? queryStep;
  @override
  State<QueryForm> createState() => _QueryFormState();
}

class _QueryFormState extends State<QueryForm> {
  late QueryController controller;
  late int queryStep;
  late int queryType;
  late int nextStep;
  QueryResponse? response;
  bool paymentRequired = false;
  bool loading = false;

  List<String> stepName = [
    "Doctor\'s \nReply",
    "Documents For Visa",
    "Payment Confirmation",
    "Upload Tickets and Visa"
  ];

  @override
  void initState() {
    queryStep = widget.queryStep!;
    queryType = widget.queryType;
    loading = true;
    fetchStepData(widget.queryId!, queryStep);
    super.initState();
  }

  void fetchStepData(int queryId, int stepNo)async{
    if(widget.queryId == 0) {
      return;
    }
    QueryResponse res = await Get.put(QueryProvider()).getQueryStepData(queryId, stepNo);
    print(res.response);
    print(res.nextStep);
    setState(() {
      // response = res;
      paymentRequired = res.paymentRequired!;
      queryStep = res.nextStep!;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: CustomAppBar(
      //   pageName: "Query Form",
      //   showDivider: true,
      // ),
      body: SafeArea(
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
                              isActive: queryStep > 1,
                              isLast: false,
                              function: () {
                                fetchStepData(widget.queryId!, queryStep);
                              })
                          : const SizedBox(),
                      CustomStep(
                          stepName: stepName[1],
                          isActive: queryStep >=
                              QueryStep.documentForVisa,
                          isLast: false,
                          function: () {
                            if (queryStep < QueryStep.documentForVisa) {
                              return;
                            }
                            queryStep =
                                QueryStep.documentForVisa;
                            // controller
                            //     .getCurrentStepData(QueryStep.documentForVisa);
                          }),
                      paymentRequired
                          ? CustomStep(
                              stepName: stepName[2],
                              isActive: queryStep >=
                                  QueryStep.payment,
                              isLast: false,
                              function: () {
                                // if (queryStep < QueryStep.payment) {
                                //   return;
                                // }
                                // controller.currentStep.value =
                                //     QueryStep.payment;
                                // controller
                                //     .getCurrentStepData(QueryStep.payment);
                              })
                          : const SizedBox(),
                      CustomStep(
                          stepName: stepName[3],
                          isActive:
                              queryStep >= QueryStep.payment,
                          isLast: true,
                          function: () {
                            // if (queryStep < QueryStep.ticketsAndVisa) {
                            //   return;
                            // }
                            // controller.currentStep.value =
                            //     QueryStep.ticketsAndVisa;
                            // controller.getCurrentStepData(QueryStep.ticketsAndVisa);
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
                        return Text("Currrent Strp: $queryStep, ");
                        // if(response!.response!.isEmpty){
                        //   switch (queryStep) {
                        //     case QueryStep.documentForVisa:
                        //       return const DocumentForVisaForm();
                        //     case QueryStep.payment:
                        //       return const PayPageForm();
                        //     case QueryStep.ticketsAndVisa:
                        //       return const UploadTicketAndVisaForm();
                        //     default:
                        //       return const SizedBox();
                        //   }
                        // }else{
                        //   switch (queryStep) {
                        //     case QueryStep.doctorResponse:
                        //       return DoctorReplyForm(response!);
                        //     case QueryStep.documentForVisa:
                        //       return EditDocumentForVisaForm(response!);
                        //     case QueryStep.payment:
                        //       return const PayPageForm();
                        //     case QueryStep.ticketsAndVisa:
                        //       return const UploadTicketAndVisaForm();
                        //     default:
                        //       return const SizedBox();
                        //   }
                        // }

                        // return Text(
                        //     "${controller.stepData[controller.currentStep]}");
                      },
                    ),
                  ),
                ),
              ],
            )),
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
      child: Container(
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
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
