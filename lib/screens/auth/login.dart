import 'package:MyMedTrip/components/CustomButton.dart';
import 'package:MyMedTrip/components/CustomImageView.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:local_auth/local_auth.dart';
import 'package:MyMedTrip/components/SmallIconButton.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:MyMedTrip/routes.dart';

import '../../controller/controllers/local_storage_controller.dart';

class LoginPage extends GetView<AuthController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final LocalAuthentication auth = LocalAuthentication();
    final LocalStorageController _storage = Get.find<LocalStorageController>();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 32,
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
                  Expanded(
                    child: CustomImageView(
                      imagePath: "assets/icons/mmt-full-logo.png",
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  Form(
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          child: IntlPhoneField(
                            style: AppStyle.txtUrbanistRegular16WhiteA700,
                            controller: controller.phoneController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.call),
                              contentPadding: const EdgeInsets.only(
                                  left: 15, bottom: 11, top: 11, right: 15),
                              hintText: "Phone",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              counterText: "",
                            ),
                            onChanged: (phone) {
                              // controller.phoneController.text = phone.number;
                            },
                            initialCountryCode: "IN",
                            showCountryFlag: false,
                            showDropdownIcon: false,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          child: GetBuilder<AuthController>(builder: (ctrl) {
                            return TextFormField(
                              controller: controller.passwordController,
                              keyboardType: TextInputType.visiblePassword,
                              obscureText: !controller.showLoginPassword,
                              obscuringCharacter: '*',
                              style: AppStyle.txtUrbanistRegular16WhiteA700,
                              decoration: InputDecoration(
                                hintText: "Password",
                                contentPadding: const EdgeInsets.only(
                                    left: 15, bottom: 11, top: 11, right: 15),
                                suffixIcon: IconButton(
                                  icon: controller.showLoginPassword
                                      ? const Icon(Icons.visibility)
                                      : const Icon(Icons.visibility_off),
                                  onPressed: () {
                                    controller.showLoginPassword =
                                        !controller.showLoginPassword;
                                    controller.update();
                                  },
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    onTap: () {
                      Get.defaultDialog(
                        title: "Reset Password",
                        contentPadding: const EdgeInsets.all(CustomSpacer.S),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              alignment: Alignment.center,
                              child: IntlPhoneField(
                                style: AppStyle.txtUrbanistRegular16WhiteA700,
                                controller: controller.phoneController,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.call),
                                  contentPadding: const EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  hintText: "Phone",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  counterText: "",
                                ),
                                onChanged: (phone) {
                                  // controller.phoneController.text = phone.completeNumber;
                                },
                                onCountryChanged: (country){
                                  // controller.phoneController.text = country.dialCode + controller.phoneController.text;
                                },
                                initialCountryCode: "IN",
                                showCountryFlag: false,
                                showDropdownIcon: false,
                              ),
                            ),
                            CustomSpacer.s(),
                            Obx(
                              () => TextFormField(
                                controller: controller.newPasswordController,
                                keyboardType: TextInputType.visiblePassword,
                                obscureText: !controller.showNewLoginPassword.value,
                                obscuringCharacter: '*',
                                style: AppStyle.txtUrbanistRegular16WhiteA700,
                                decoration: InputDecoration(
                                  hintText: "New Password",
                                  contentPadding: const EdgeInsets.only(
                                      left: 15, bottom: 11, top: 11, right: 15),
                                  suffixIcon: IconButton(
                                    icon: controller.showNewLoginPassword.value
                                        ? const Icon(Icons.visibility)
                                        : const Icon(Icons.visibility_off),
                                    onPressed: () {
                                      controller.showNewLoginPassword.value =
                                      !controller.showNewLoginPassword.value;
                                    },
                                  ),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            CustomSpacer.s(),
                            CustomButton(
                              onTap: () {
                                controller.resetPassword();
                              },
                              text: "Send Reset Request",
                              padding: ButtonPadding.PaddingAll8,
                            ),
                          ],
                        )
                      );
                    },
                    text: "Forgot password?",
                    alignment: Alignment.bottomRight,
                    variant: ButtonVariant.OnlyText,
                    padding: ButtonPadding.PaddingAll8,
                    fontStyle: ButtonFontStyle.UrbanistSemiBold16WhiteA700,
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
                      CustomButton(
                        onTap: () {
                          controller.passwordController.text = "";
                          Get.toNamed(Routes.registerFirstStep);
                        },
                        text: "sign up here?",
                        alignment: Alignment.bottomLeft,
                        variant: ButtonVariant.OnlyText,
                        padding: ButtonPadding.PaddingAll8,
                        fontStyle: ButtonFontStyle.UrbanistSemiBold16WhiteA700,
                      ),
                    ],
                  ),
                  CustomButton(
                    onTap: () {
                      controller.login();
                    },
                    text: "Sign in",
                    padding: ButtonPadding.PaddingAll8,
                  ),
                  CustomButton(
                    onTap: () async {
                      try {
                        var data = await auth.authenticate(
                            localizedReason: "Use face id to authenticate",
                            options: const AuthenticationOptions(
                              stickyAuth: true,
                            ));
                        if (data) {
                          String? bioId = _storage.get('biometric');
                          if (bioId == null || bioId.isEmpty) {
                            Get.snackbar("Verification Failed",
                                "Please re enable biometric from profile settings to use it",
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            controller.loginWithBiometric(bioId);
                          }
                        }
                      } on PlatformException catch (e) {
                        Get.snackbar("Not Supported", e.message.toString(),
                            snackPosition: SnackPosition.BOTTOM);
                      } catch (e) {
                        print(e);
                      }
                    },
                    text: "Biometric login",
                    alignment: Alignment.center,
                    variant: ButtonVariant.OnlyText,
                    padding: ButtonPadding.PaddingAll8,
                    fontStyle: ButtonFontStyle.UrbanistSemiBold16Blue,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget phoneLogin() {
    return LayoutBuilder(builder: (builder, constraint) {
      return Form(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              width: constraint.maxWidth,
              child: IntlPhoneField(
                style: AppStyle.txtUrbanistRegular16WhiteA700,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.call),
                  contentPadding: const EdgeInsets.only(
                      left: 15, bottom: 11, top: 11, right: 15),
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
                showCountryFlag: false,
                showDropdownIcon: false,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: constraint.maxWidth,
              child: GetBuilder<AuthController>(builder: (ctrl) {
                return TextFormField(
                  controller: controller.passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !controller.showLoginPassword,
                  obscuringCharacter: '*',
                  style: AppStyle.txtUrbanistRegular16WhiteA700,
                  decoration: InputDecoration(
                    hintText: "Password",
                    contentPadding: const EdgeInsets.only(
                        left: 15, bottom: 11, top: 11, right: 15),
                    suffixIcon: IconButton(
                      icon: controller.showLoginPassword
                          ? const Icon(Icons.visibility)
                          : const Icon(Icons.visibility_off),
                      onPressed: () {
                        controller.showLoginPassword =
                            !controller.showLoginPassword;
                        controller.update();
                      },
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }),
            ),
          ],
        ),
      );
    });
  }
}
