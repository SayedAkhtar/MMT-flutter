// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/controller/controllers/auth_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/screens/Settings_page/help_page.dart';
import 'package:mmt_/screens/login/verify_confirm.dart';

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
  List _otp = ['','','',''];

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: CustomAppBar(
        pageName: "Let's Verify",
        showDivider: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Text(
              "We've send a verification code to ${_controller.phoneController.text}",
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
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: TextField(
                    style: TextStyle(
                      fontSize: 26.0,
                    ),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        _otp[0]=text;
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: TextField(
                    style: TextStyle(fontSize: 26.0),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        _otp[1] = text;
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: TextField(
                    style: TextStyle(fontSize: 26.0),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        _otp[2] = text;
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
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width / 5,
                  child: TextField(
                    style: TextStyle(fontSize: 26.0),
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      if (text.isNotEmpty) {
                        _otp[3] = text;
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
                ),
              ],
            ),
            CustomSpacer.m(),
            TextButton(
              onPressed: () {
                _controller.resendOtp();
              },
              child: Text(
                _start == 0 ? "Resend Now" : "Resend in ${_start}",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: MYcolors.bluecolor),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: () {
                if(_otp.length == 4){
                  _controller.verifyOtp(otp: _otp.join());
                }
              },
              child: Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: _otp.length == 4 ? MYcolors.bluecolor : MYcolors.greycolor,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: Text(
                  "Verify",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MYcolors.whitecolor,
                      // fontFamily: "Brandon",
                      fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
