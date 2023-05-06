// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/constants/colors.dart';
import 'package:mmt_/constants/razorpay_constants.dart';
import 'package:mmt_/controller/controllers/teleconsult_controller.dart';
import 'package:mmt_/helper/Loaders.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Video_consult/thankyou.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Schedule_page extends StatefulWidget {
  const Schedule_page({super.key});

  @override
  State<Schedule_page> createState() => _Schedule_pageState();
}

class _Schedule_pageState extends State<Schedule_page> with TickerProviderStateMixin {
  late AnimationController _animationController;
  final Razorpay _razorpay = Razorpay();
  late TeleconsultController _controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    _controller = Get.find<TeleconsultController>();
    _animationController = AnimationController(vsync: this);
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
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
          appBar: CustomAppBar(
            pageName: '',
          ),
      body: Column(
        children: [
          Lottie.asset("assets/lottie/appointment-schedule.json"),
          Text(
            "You have Selected : ${_controller.selectedSlot.dayName} ${new DateTime.fromMillisecondsSinceEpoch(_controller.selectedSlot.timestamp * 1000).isUtc}",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
          Text(
            "Or Want to Rechedule your video Consulation ?",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.02,
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: MYcolors.greycolor),
            alignment: Alignment.centerLeft,
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.9,
            child: Text(
              "  Rechedule",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.03,
          ),
          ElevatedButton(
            onPressed: () {
              // _razorpay.open(RazorpayConstants.getOptionsForTeleconsultation(amount: 190));
              Get.toNamed(Routes.teleconsultationConfirm);
            },
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100)),
                minimumSize: Size(double.infinity, 40)),
            child: Text(
              "Submit".tr,
              style: TextStyle(
                color: MYcolors.whitecolor,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
