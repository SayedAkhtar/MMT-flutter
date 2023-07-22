// ignore_for_file: prefer_const_constructors

import 'package:MyMedTrip/components/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/theme/app_style.dart';

class SignupHerePage extends StatefulWidget {
  const SignupHerePage({super.key});

  @override
  State<SignupHerePage> createState() => _SignupHerePageState();
}

class _SignupHerePageState extends State<SignupHerePage> {
  static const List<String> gender = ['Male', 'Female', 'Other'];
  late AuthController _authController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _countryCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _gender = gender.first;
  @override
  void initState() {
    super.initState();
    _authController = Get.find<AuthController>();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _countryCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Sign Up",
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
                      TextFormField(
                        textAlign: TextAlign.start,
                        style: AppStyle.txtUrbanistRegular16WhiteA700,
                        controller: _nameController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Mobile number is required';
                          }
                          return null;
                        },
                        // textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          // prefixIcon: Icon(Icons.call),
                          hintText: "Name".tr,
                          // hintStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
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
                          suffixIcon: Icon(Icons.arrow_drop_down),
                        ),
                        initialCountryCode: 'IN',
                        showDropdownIcon: false,
                        showCountryFlag: false,
                        onChanged: (phone) {
                          _phoneController.text = phone.number;
                          _countryCodeController.text = phone.countryCode;
                        },
                      ),
                      DropdownButtonFormField<String>(
                          value: _gender,
                          style: AppStyle.txtUrbanistRegular16WhiteA700,
                          elevation: 16,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            // prefixIcon: Icon(Icons.call),
                            hintText: "Select Gender".tr,
                            // hintStyle: TextStyle(fontSize: 13),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onChanged: (String? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _gender = value!;
                            });
                          },
                          items:
                              gender.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList()),
                      TextFormField(
                        textAlign: TextAlign.start,
                        style: AppStyle.txtUrbanistRegular16WhiteA700,
                        controller: _passwordController,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please input your password';
                          }
                          if (val.length < 8) {
                            return "Password must be least 8 characters";
                          }
                          return null;
                        },
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          hintText: "Enter password".tr,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      TextFormField(
                        textAlign: TextAlign.start,
                        style: AppStyle.txtUrbanistRegular16WhiteA700,
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (_passwordController.text != val) {
                            return "Confirm password and Password must be same";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          // prefixIcon: Icon(Icons.call),
                          hintText: "Confirm password".tr,
                          // hintStyle: TextStyle(fontSize: 13),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(width: 1.0)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            CustomButton(
              onTap: () {
                if(!_formKey.currentState!.validate()){
                  return;
                }
                print(_gender);
                _authController.register(
                  _nameController.text,
                  _passwordController.text,
                  _phoneController.text,
                  _gender.toLowerCase(),
                  _countryCodeController.text,
                );
              },
              text: "Submit".tr,
            )
          ],
        ),
      ),
      // backgroundColor: MYcolors.bluecolor,
    );
  }
}
