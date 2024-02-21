// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:MyMedTrip/components/CustomButton.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/helper/Loaders.dart';
import 'package:MyMedTrip/models/user_model.dart';
import 'package:MyMedTrip/providers/auth_provider.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/theme/app_style.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool otpSent = false;
  bool wait = false;
  bool showPassword = false;
  late Timer _timer;
  int _start = 60;

  final AuthProvider provider = Get.put(AuthProvider());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Forgot Password".tr,
        showDivider: true,
        showBack: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Form(
                  key: _formKey,
                  child: Wrap(
                    runSpacing: CustomSpacer.S,
                    children: [
                      IntlPhoneField(
                        textAlign: TextAlign.start,
                        style: AppStyle.txtUrbanistRegular16WhiteA700,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Phone Number".tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          counterText: "",
                          prefixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        initialCountryCode: 'IN',
                        showDropdownIcon: false,
                        showCountryFlag: false,
                        onChanged: (phone) {
                          _phoneController.text = phone.number;
                        },
                        validator: (value){
                          if (_phoneController.text.isNotEmpty) {
                            return 'Please enter your mobile number'.tr;
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        textAlign: TextAlign.start,
                        style: AppStyle.txtUrbanistRegular16WhiteA700,
                        controller: _passwordController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please input your password'.tr;
                          }
                          if (val.length < 8) {
                            return "Password must be least 8 characters".tr;
                          }
                          return null;
                        },
                        obscureText: !showPassword,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "New Password ".tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                            suffixIcon: IconButton(
                              icon: showPassword
                                  ? const Icon(Icons.visibility)
                                  : const Icon(Icons.visibility_off),
                              onPressed: () {
                                setState(() {
                                  showPassword = !showPassword;
                                });
                              },
                            )
                        ),
                      ),
                      Builder(builder: (ctx){
                        if(otpSent){
                          return Column(
                            // crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextFormField(
                                controller: _otpController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                maxLength: 6,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter the OTP to proceed'.tr;
                                  }
                                  if (value.length < 6) {
                                    return "";
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Please enter the OTP to proceed".tr,
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  if(_start != 0) return;
                                  setState(() {
                                    _start = 60;
                                  });
                                  startTimer();
                                  provider.resendOtp(phone: _phoneController.text);
                                },
                                child: Text(
                                  _start == 0 ? "Resend Now".tr : "${"Resend in".tr} $_start",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 16,
                                      color: MYcolors.bluecolor),
                                ),
                              )
                            ],
                          );
                        }else{
                          return SizedBox();
                        }
                      })
                    ],
                  ),
                ),
              ),
            ),
            !otpSent?
            CustomButton(
              variant: wait ? ButtonVariant.FillGray800 : ButtonVariant.Default,
              onTap: () async {
                if(!_formKey.currentState!.validate()){
                  return;
                }
                setState(() {
                  wait = true;
                });
                if(await provider.resetPassword(phone: _phoneController.text)) {
                  setState(() {
                    otpSent = true;
                  });
                  startTimer();
                }
                setState(() {
                  wait = false;
                });
              },
              text: "Send OTP".tr,
              prefixWidget: wait ?Container(
                height: 22,
                width: 22,
                margin: EdgeInsets.only(right: 8),
                child: CircularProgressIndicator(),
              ): SizedBox(),
            ):CustomButton(
              variant: wait ? ButtonVariant.FillGray800 : ButtonVariant.Default,
              onTap: () async {
                if(!_formKey.currentState!.validate()){
                  return;
                }
                setState(() {
                  wait = true;
                });
                if(otpSent && _otpController.text.isNotEmpty){
                  LocalUser? res = await provider.validateOtp(_otpController.text, _phoneController.text, 'forgot_password', password: _passwordController.text);
                  if(res != null){
                    Loaders.successDialog("Password reset successfully".tr, barrierDismissible: false);
                    await Future.delayed(Duration(seconds: 2));
                    Get.offAllNamed(Routes.login);
                  }
                }
                setState(() {
                  wait = false;
                });
              },
              text: "Submit".tr,
              prefixWidget: wait ?Container(
                height: 22,
                width: 22,
                margin: EdgeInsets.only(right: 8),
                child: CircularProgressIndicator(),
              ): SizedBox(),
            )
          ],
        ),
      ),
      // backgroundColor: MYcolors.bluecolor,
    );
  }
}
