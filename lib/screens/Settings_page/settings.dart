// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:mmt_/components/CustomAppBar.dart';
import 'package:mmt_/components/FormLabel.dart';
import 'package:mmt_/components/Heading.dart';
import 'package:mmt_/components/SmallIconButton.dart';
import 'package:mmt_/components/StyledTextFormField.dart';
import 'package:mmt_/components/TranslatedText.dart';
import 'package:mmt_/controller/controllers/auth_controller.dart';
import 'package:mmt_/controller/controllers/local_storage_controller.dart';
import 'package:mmt_/controller/controllers/user_controller.dart';
import 'package:mmt_/helper/CustomSpacer.dart';
import 'package:mmt_/helper/Utils.dart';
import 'package:mmt_/routes.dart';
import 'package:mmt_/screens/Settings_page/about_page.dart';
import 'package:mmt_/screens/Settings_page/change_language_page.dart';
import 'package:mmt_/screens/Settings_page/help_page.dart';
import 'package:mmt_/screens/Settings_page/profile_page.dart';
import 'package:mmt_/screens/login/sing_up.dart';

import '../../constants/colors.dart';

class User_Profile extends GetView<UserController> {
  const User_Profile({super.key});
  @override
  Widget build(BuildContext context) {
    final LocalAuthentication auth = LocalAuthentication();
    final AuthController _authController = Get.find<AuthController>();
    final LocalStorageController _storage = Get.find<LocalStorageController>();
    print(controller.user?.image);
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Settings",
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
                          height: MediaQuery.of(context).size.height * 0.15,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: controller.user?.image != null && controller.user!.image!.isNotEmpty
                              ? Image.network(
                                  Utils.absoluteUri(controller.user?.image))
                              : Image.asset("Images/PR.png"),
                        ),
                        CustomSpacer.xs(),
                        Text(
                          controller.user?.name ?? "",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
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
                      Get.defaultDialog(
                          title: "Change Password",
                        content: SizedBox(
                          height: 200,
                          child: Wrap(
                            runSpacing: CustomSpacer.XS,
                            children: [
                            TranslatedText(text: "Old Password : "),
                            StyledTextFormField(
                              controller: controller.oldPasswordController,
                              hintText: "",
                            ),
                            TranslatedText(text: "New Password : "),
                            StyledTextFormField(
                              controller: controller.passwordController,
                              hintText: "",
                            ),
                            Spacer(),
                            ElevatedButton(onPressed: (){
                              print(controller.passwordController.text);
                              controller.updatePassword(controller.user!.id, _authController.oldPasswordController.text, _authController.passwordController.text);
                            }, child: Text('Submit'))
                          ],),
                        )
                      );
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
