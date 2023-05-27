// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/controller/controllers/auth_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/screens/Home_screens/home_bottom.dart';
import 'package:mmt_/constants/colors.dart';

class Singup_here_page extends StatefulWidget {
  const Singup_here_page({super.key});

  @override
  State<Singup_here_page> createState() => _Singup_here_pageState();
}

class _Singup_here_pageState extends State<Singup_here_page> {
  static const List<String> gender = ['Male','Female','Other'];
  String dropdownValue = gender.first;
  late AuthController _authController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _authController = Get.put(AuthController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(pageName: "Sign Up", showDivider: true, showBack: true,),
      body: Padding(
    padding: const EdgeInsets.all(CustomSpacer.S),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Form(
            key: _authController.registerFormKey,
            child: Wrap(
              runSpacing: CustomSpacer.S,
              children: [
                TextFormField(
                  textAlign: TextAlign.start,
                  controller: _authController.nameController,
                  validator: (val){
                    if(val!.isEmpty) {
                      return 'Mobile number is required';
                    }
                    if(val.length < 6 && val.length > 10){
                      return "Please enter a valid phone number";
                    }
                    return null;
                  },
                  // textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    // prefixIcon: Icon(Icons.call),
                    hintText: "Name".tr,
                    // hintStyle: TextStyle(fontSize: 13),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                IntlPhoneField(
                  textAlign: TextAlign.start,
                  decoration:  InputDecoration(
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Phone Number".tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    counterText: "",
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    _authController.phoneController.text = phone.number;
                    _authController.countryCode = phone.countryCode;
                  },
                ),
                DropdownButtonFormField<String>(
                    value: dropdownValue,
                    elevation: 16,
                    decoration: InputDecoration(
                      contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      // prefixIcon: Icon(Icons.call),
                      hintText: "Enter password".tr,
                      // hintStyle: TextStyle(fontSize: 13),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        dropdownValue = value!;
                        _authController.gender.value = value;
                      });
                    },
                    items: gender.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                ),
                TextFormField(
                  textAlign: TextAlign.start,
                  controller: _authController.passwordController,
                  validator: (val){
                      if(val!.isEmpty) {
                        return 'Please input your password';
                      }
                      if(val.length < 8){
                        return "Password must be least 8 characters";
                      }
                      return null;
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: "Enter password".tr,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                TextFormField(
                  textAlign: TextAlign.start,
                  validator: (val){
                    if(val!.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if(_authController.passwordController.text != val){
                      return "Confirm password and Password must be same";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
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
          Spacer(),
          GestureDetector(
            onTap: () {
              _authController.register();
            },
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 0.05,
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: MYcolors.bluecolor,
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                "Submit".tr,
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: MYcolors.whitecolor,
                    fontFamily: "Brandon",
                    fontSize: 18),
              ),
            ),
          ),
        ],
      ),
    ),
      ),
      // backgroundColor: MYcolors.bluecolor,
    );
  }
}
