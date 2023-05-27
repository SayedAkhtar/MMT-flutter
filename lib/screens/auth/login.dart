import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mmt_/components/SmallIconButton.dart';
import 'package:mmt_/constants/colors.dart';
import 'package:mmt_/controller/controllers/auth_controller.dart';
import 'package:mmt_/routes.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Column(
            children: [
              SafeArea(
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    SmallIconButton(
                        onTap: () {
                          Get.toNamed(Routes.languageSelector);
                        },
                        icon: Icons.arrow_back_ios_new_outlined),
                    const Spacer(),
                    SmallIconButton(
                        onTap: () {}, icon: Icons.question_mark_rounded)
                  ],
                ),
              ),
              const Expanded(
                child: Center(
                  child: Text(
                    "MyMedTrip",
                    style: TextStyle(
                        fontFamily: "Brandon",
                        fontSize: 50,
                        color: MYcolors.blacklightcolors),
                  ),
                ),
              ),
              SizedBox(
                height: 135,
                child: SingleChildScrollView(
                  child: GetBuilder<AuthController>(
                      init: controller,
                      builder: (_) {
                        return phoneLogin();
                      }),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.58,
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: const Text(
                      "Forgot password ?",
                      style: TextStyle(
                          fontFamily: "BrandonMed",
                          fontSize: 15,
                          color: MYcolors.blacklightcolors),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(
                        fontFamily: "Brandon",
                        fontSize: 15,
                        color: MYcolors.blacklightcolors),
                  ),
                  GestureDetector(
                    onTap: () {
                      controller.passwordController.text = "";
                      Get.toNamed(Routes.registerFirstStep);
                    },
                    child: const Text(
                      "sign up here?",
                      style: TextStyle(
                          fontFamily: "Brandon",
                          fontSize: 15,
                          color: MYcolors.bluecolor),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
              GestureDetector(
                onTap: () {
                  controller.phoneLogin();
                },
                child: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.05,
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: MYcolors.bluecolor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Text(
                    "Sign in",
                    style: TextStyle(
                        // fontWeight: FontWeight.bold,
                        color: MYcolors.whitecolor,
                        fontFamily: "Brandon",
                        fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
              ),
              GestureDetector(
                onTap: () {
                  //Get.to(Login_fingerprint_page());
                },
                child: const Text(
                  "Biometric login",
                  style: TextStyle(
                      fontFamily: "Brandon",
                      fontSize: 15,
                      color: MYcolors.bluecolor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget phoneLogin() {
    return LayoutBuilder(builder: (builder, constraint) {
      return Form(
        key: controller.phoneLoginFormKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: constraint.maxWidth,
              child: IntlPhoneField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.call),
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "Phone",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  counterText: "",
                ),
                onChanged: (phone) {
                  controller.phoneController.text = phone.number;
                },
                initialCountryCode: "IN",
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: constraint.maxWidth,
              child: GetBuilder<AuthController>(
                builder: (ctrl) {
                  return TextFormField(
                    controller: controller.passwordController,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: !controller.showLoginPassword,
                    obscuringCharacter: '*',
                    decoration: InputDecoration(
                      hintText: "Password",
                      contentPadding:
                          const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                      prefixIcon: const Icon(Icons.key),
                      suffixIcon: IconButton(
                        icon: controller.showLoginPassword ? const Icon(Icons.visibility):const Icon(Icons.visibility_off)  ,
                        onPressed: () {
                          controller.showLoginPassword = !controller.showLoginPassword;
                          controller.update();
                        },
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                }
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget emailLogin() {
    return LayoutBuilder(builder: (context, constraints) {
      return Form(
        key: controller.emailLoginFormKey,
        autovalidateMode: AutovalidateMode.always,
        child: Column(
          children: [
            SizedBox(
              // alignment: Alignment.center,
              // height: MediaQuery.of(context).size.height * 0.05,
              width: constraints.maxWidth,
              child: TextFormField(
                validator: controller.validator,
                controller: controller.emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.call),
                  contentPadding:
                      const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                  hintText: "Email",
                  // hintStyle: TextStyle(fontSize: 13),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              // height: MediaQuery.of(context).size.height * 0.05,
              width: constraints.maxWidth,
              child: TextFormField(
                validator: controller.validator,
                controller: controller.passwordController,
                decoration: InputDecoration(
                  hintText: "Password",
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 11, top: 11, right: 15),
                  // hintStyle: TextStyle(fontSize: 13),
                  // prefixText: "Password",
                  prefixIcon: const Icon(Icons.key),
                  suffixIcon: const Icon(Icons.visibility),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
