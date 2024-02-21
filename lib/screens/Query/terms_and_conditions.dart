
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/models/query_response_model.dart';
import 'package:MyMedTrip/screens/Query/query_form.dart';

import '../../constants/colors.dart';

class Terms_and_Conditions extends GetView<QueryController> {
  const Terms_and_Conditions(this.response, {super.key});
  final QueryResponse response;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageName: "Terms and Conditions".tr, showDivider: true,),
      body: Padding(
    padding: const EdgeInsets.all(CustomSpacer.S),
    child: Column(
      children: [
        Text(
          """Thank you for sharing your reports with us. We will be sharing it only with the concerned doctor for their medical opinion and will share with you their reply. We do not share any personal information with anyone apart from the doctor for opinion.""".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        Spacer(),
        GestureDetector(
          onTap: () {
            // if(controller.currentStep.value == QueryStep.documentForVisa && !controller.showPaymentPage){
            //   controller.currentStep.value = controller.currentStep.value + 2;
            // }else{
            //   controller.currentStep.value = controller.currentStep.value + 1;
            // }
            print(response.queryId!);
            Get.offAll(() => QueryForm(response.queryType!, queryId: response.queryId,));
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: MYcolors.bluecolor),
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              "Accept".tr,
              style: TextStyle(
                color: MYcolors.whitecolor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
      ),
    );
  }
}
