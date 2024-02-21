// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';

import '../../constants/colors.dart';

class Verify_page extends StatefulWidget {
  const Verify_page({super.key});

  @override
  State<Verify_page> createState() => _Verify_pageState();
}

class _Verify_pageState extends State<Verify_page> {
  late Timer _timer;
  int _start = 60;
  late AuthController _controller;
  final List _otp = ['','','','', '', ''];
  String errorText = "";

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    _controller = Get.find<AuthController>();
    startTimer();
    // _controller.resendOtp();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
    pageName: "Let's Verify".tr,
    showDivider: true,
      ),
      body: Padding(
    padding: const EdgeInsets.all(CustomSpacer.S),
    child: Column(
      children: [
        Text(
          "${"We've send a verification code to".tr} ${_controller.phoneController.text}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
          textAlign: TextAlign.center,
        ),
        CustomSpacer.m(),
        Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.spaceBetween,
          runAlignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10,
          children:
            List.generate(6, (index) => SizedBox(
              width: MediaQuery.of(context).size.width / 8,
              child: TextField(
                style: TextStyle(
                  fontSize: 26.0,
                ),
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                onChanged: (text) {
                  if (text.isNotEmpty) {
                    _otp[index]=text;
                    FocusScope.of(context).nextFocus();
                  }
                },
                maxLength: 1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(8)),
                    filled: true,
                    fillColor: MYcolors.greycolor,
                    counterText: ""),
              ),
            )).toList()
          ,
        ),
        CustomSpacer.m(),
        TextButton(
          onPressed: () {
            _controller.resendOtp();
          },
          child: Text(
            _start == 0 ? "Resend Now".tr : "${"Resend in".tr} $_start",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: MYcolors.bluecolor),
          ),
        ),
        errorText.isNotEmpty ? Text(errorText) : SizedBox(),
        Spacer(),
        GestureDetector(
          onTap: () {
            if(_otp.length == 6){
              _controller.verifyOtp(otp: _otp.join());
            }else{
              setState(() {
                errorText = "Please enter the OTP to proceed".tr;
              });
            }
          },
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: _otp.length == 6 ? MYcolors.bluecolor : MYcolors.greycolor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              "Verify".tr,
              style: AppStyle.txtUrbanistRomanBold20.copyWith(color: Colors.white),
            ),
          ),
        ),
      ],
    ),
      ),
    );
  }
}
