// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/constants/razorpay_constants.dart';
import 'package:mmt_/controller/controllers/query_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Medical_visa/upload_ticket_visa.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../constants/colors.dart';

class PayPageForm extends StatefulWidget {
  const PayPageForm({super.key});

  @override
  State<PayPageForm> createState() => _PayPageFormState();
}

class _PayPageFormState extends State<PayPageForm> {
  final Razorpay _razorpay = Razorpay();
  final QueryController _controller = Get.find<QueryController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _controller.selectedQuery = 3;
    _controller.handleSuccesfulPaymentResponse(response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("====== Error ======");
    if(response.message != null){
      Loaders.errorDialog(response.message!);
    }
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print(response.walletName);
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Column(
        children: [
          Expanded(child:
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '\$' "15",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                  ),
                ),
                CustomSpacer.s(),
                Text(
                  "Please complete the payment to confirm your query and\nbegin the process with MyMedicalTourism",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            )
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              _razorpay.open(RazorpayConstants.getOptionsForQueryConfirmation());
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: MYcolors.bluecolor),
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Text(
                "Pay".tr,
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
    ));
  }
}
