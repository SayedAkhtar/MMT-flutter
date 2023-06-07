import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/models/query_screen_model.dart';
import 'package:MyMedTrip/screens/Medical_visa/doctor_reply.dart';
import 'package:MyMedTrip/screens/Query/doctor_reply_form.dart';
import 'package:MyMedTrip/screens/Query/document_visa_form.dart';
import 'package:MyMedTrip/screens/Query/pay_page_form.dart';
import 'package:MyMedTrip/screens/Query/upload_ticket_visa_form.dart';

import '../../constants/colors.dart';
import '../../constants/query_step_name.dart';
import '../../helper/CustomSpacer.dart';

class QueryForm extends StatefulWidget {
  const QueryForm({Key? key}) : super(key: key);

  @override
  State<QueryForm> createState() => _QueryFormState();
}

class _QueryFormState extends State<QueryForm> {
  late QueryController controller;
  int queryStep = 2;
  List<String> stepName = [
    "Doctor\'s \nReply",
    "Documents For Visa",
    "Payment Confirmation",
    "Upload Tickets and Visa"
  ];

  @override
  void initState() {
    controller = Get.find<QueryController>();

    if(controller.queryType == 2){
      queryStep = QueryStep.documentForVisa;
    }else{
      queryStep = controller.queryScreen.activeQuery![controller.selectedIndex].currentStep!;
    }
    super.initState();
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
                      (controller.queryType == QueryType.query)?
                      CustomStep(
                      stepName: stepName[0],
                      isActive: controller.currentStep.value > 1,
                      isLast: false,
                      function: () {
                        controller.currentStep.value = QueryStep.doctorResponse;
                        controller.getCurrentStepData(QueryStep.doctorResponse);
                      }):const SizedBox(),
                      CustomStep(
                          stepName: stepName[1],
                          isActive: controller.currentStep.value >= QueryStep.documentForVisa ,
                          isLast: false,
                          function: () {
                            if(queryStep < QueryStep.documentForVisa){
                              return;
                            }
                            controller.currentStep.value = QueryStep.documentForVisa;
                            controller.getCurrentStepData(QueryStep.documentForVisa);
                      }),
                      controller.showPaymentPage ?
                      CustomStep(
                          stepName: stepName[2],
                          isActive: controller.currentStep.value >= QueryStep.payment,
                          isLast: false,
                          function: () {
                            if(queryStep < QueryStep.payment){
                              return;
                            }
                            controller.currentStep.value = QueryStep.payment;
                            controller.getCurrentStepData(QueryStep.payment);
                      }):const SizedBox(),
                      CustomStep(
                          stepName: stepName[3],
                          isActive: controller.currentStep.value >= QueryStep.payment,
                          isLast: true,
                          function: () {
                            if(queryStep < QueryStep.ticketsAndVisa){
                              return;
                            }
                            controller.currentStep.value = QueryStep.ticketsAndVisa;
                            // controller.getCurrentStepData(QueryStep.ticketsAndVisa);
                      }),
                    ],
                  ),
                ),
                Expanded(
                  // height: MediaQuery.of(context).size.height - 120.0 - AppBar().preferredSize.height,
                  // color: Colors.greenAccent,
                  child: Container(
                    padding: EdgeInsets.all(CustomSpacer.S),
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
                    child: Obx(() {
                      // print(controller.stepData);
                      switch(controller.currentStep.value){
                        case QueryStep.doctorResponse:
                          return DoctorReplyForm();
                        case QueryStep.documentForVisa:
                          return const DocumentForVisaForm();
                        case QueryStep.payment:
                          return const PayPageForm();
                        case QueryStep.ticketsAndVisa:
                          return const UploadTicketAndVisaForm();
                      }
                      return Text("${controller.stepData[controller.currentStep]}");
                    }),
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
