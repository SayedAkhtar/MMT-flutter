// ignore_for_file: prefer_const_constructors

import 'package:MyMedTrip/components/CustomImageView.dart';
import 'package:MyMedTrip/screens/Settings_page/change_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/TranslatedText.dart';
import 'package:MyMedTrip/controller/controllers/auth_controller.dart';
import 'package:MyMedTrip/controller/controllers/local_storage_controller.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:MyMedTrip/routes.dart';
import 'package:MyMedTrip/screens/Settings_page/about_page.dart';
import 'package:MyMedTrip/screens/Settings_page/change_language_page.dart';

import '../../constants/colors.dart';

class User_Profile extends GetView<UserController> {
  const User_Profile({super.key});
  @override
  Widget build(BuildContext context) {
    final LocalAuthentication auth = LocalAuthentication();
    final AuthController _authController = Get.find<AuthController>();
    final LocalStorageController _storage = Get.find<LocalStorageController>();
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Settings",
        backFunction: (){
          Get.toNamed(Routes.home);
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Flexible(
                  flex: 0,
                  child: Center(
                    child: Column(
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          clipBehavior: Clip.hardEdge,
                          child: GetBuilder(
                            builder: (UserController controller) {
                              return CustomImageView(url: controller.user!.image);
                            }
                          ),
                        ),
                        CustomSpacer.xs(),
                        GetBuilder(
                          builder: (UserController controller) {
                            return Text(
                              controller.user?.name ?? "",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  )),
              Expanded(
                child: ListView(
                  children: [
                    CustomSpacer.s(),
                    _menuLinks(context, onTap: () {
                      Get.toNamed(Routes.profile);
                    }, label: "Profile"),
                    _menuLinks(context, onTap: () {
                      Get.toNamed(Routes.listFamily);
                    }, label: "Family Members"),
                    _menuLinks(
                      context,
                      onTap: () async {
                        late List<BiometricType> availableBiometrics;
                        try {
                          availableBiometrics =
                              await auth.getAvailableBiometrics();
                        } on PlatformException catch (e) {
                          availableBiometrics = <BiometricType>[];
                          print(e);
                        }
                        try {
                          var data = await auth.authenticate(
                              localizedReason: "Use face id to authenticate",
                              options: AuthenticationOptions(
                                stickyAuth: true,
                              ));
                          if(data){
                            String? key = _storage.get('biometric');
                            if(key == null){
                              controller.updateBiometric(controller.user!.id, controller.user!.gender, controller.user!.id);
                              _storage.set(key : 'biometric', value: controller.user!.id.toString());
                            }else{
                              controller.updateBiometric(controller.user!.id, controller.user!.gender, null);
                              _storage.delete(key: 'biometric');
                            }
                          }
                        } on PlatformException catch ( e) {
                          Get.snackbar("Not Supported",e.message.toString(), snackPosition: SnackPosition.BOTTOM);
                          print(e.message);
                        }catch(e){
                          print(e.toString());
                        }
                      },
                      label: "Biometric",
                      linkAction: GetBuilder<UserController>(
                        builder: (ctrl) {
                          return Switch(
                            value: controller.user?.biometric == null ? false: true,
                            onChanged: (value) {
                            },
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          );
                        }
                      ),
                    ),
                    _menuLinks(context, onTap: () {
                      Get.to(const ChangePassword());
                    }, label: "Change Password"),
                    _menuLinks(context,
                        onTap: () {},
                        label: "Notifications",
                        linkAction: Switch(value: false, onChanged: (value) {}),
                        subLabel:
                            "Manage if you want to receive updates about promotion features or news"),
                    _menuLinks(context, onTap: () {
                      Get.to(ChangeLanguagePage());
                    }, label: "App Language"),
                    _menuLinks(context, onTap: () {
                      Get.toNamed(Routes.support);
                    }, label: "Support"),
                    _menuLinks(context, onTap: () {
                      Get.to(() => AboutApp());
                    }, label: "About"),
                    TextButton(
                      style: TextButton.styleFrom(
                          foregroundColor: MYcolors.blackcolor,
                          alignment: Alignment.topLeft,
                          padding: const EdgeInsets.symmetric(
                              vertical: CustomSpacer.XS,
                              horizontal: CustomSpacer.S)),
                      onPressed: () {
                        _authController.logout();
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TranslatedText(
                            text: "Logout",
                            style: TextStyle(
                              color: MYcolors.redcolor,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuLinks(BuildContext context,
      {required VoidCallback onTap,
      required String label,
      Widget? linkAction,
      String subLabel = ""}) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: const EdgeInsets.symmetric(
              vertical: CustomSpacer.XS, horizontal: CustomSpacer.S),
        decoration: BoxDecoration(
            border:
                Border(bottom: BorderSide(color: context.theme.dividerColor))),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TranslatedText(
                    text: label,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subLabel != ""
                      ? TranslatedText(
                          text: subLabel,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
            linkAction ?? SizedBox(),
          ],
        ),
      ),
    );
  }
}
