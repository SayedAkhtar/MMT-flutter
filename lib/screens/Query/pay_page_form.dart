// ignore_for_file: prefer_const_constructors

import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/models/query_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/constants/razorpay_constants.dart';
import 'package:MyMedTrip/controller/controllers/query_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../../constants/colors.dart';
import '../../models/user_model.dart';

class PayPageForm extends StatefulWidget {
  const PayPageForm(this.response, {super.key});
  final QueryResponse response;
  @override
  State<PayPageForm> createState() => _PayPageFormState();
}

class _PayPageFormState extends State<PayPageForm> {
  final Razorpay _razorpay = Razorpay();
  final QueryController _controller = Get.find<QueryController>();
  @override
  void initState() {
    // TODO: implement initState
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    _controller.handleSuccesfulPaymentResponse(widget.response.queryId!, response);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("====== Error ======");
    print(response.error);
    print(response.code);
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
                  "Please complete the payment to confirm your query and\nbegin the process with MyMedicalTourism".tr,
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
              LocalUser user= Get.find<UserController>().user!;
              _razorpay.open(RazorpayConstants.getOptionsForQueryConfirmation(phoneNumber: user.phoneNo!, name: user.name!));
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
