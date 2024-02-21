import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/CustomElevetedButton.dart';
import 'package:MyMedTrip/components/FormLabel.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final GlobalKey formKey = GlobalKey();
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  late UserController userController;
  @override
  void initState() {
    // TODO: implement initState
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
    userController = Get.find<UserController>();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        pageName: "Change Password".tr,
        showDivider: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(CustomSpacer.S),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Wrap(
              runSpacing: CustomSpacer.XS,
              children: [
                FormLabel("Old Password :".tr),
                TextFormField(
                  controller: oldPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password'.tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: '',
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                FormLabel("New Password :".tr),
                TextFormField(
                  controller: newPasswordController,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Please enter new password".tr;
                    }
                    if(value.length < 8){
                      return "Minimum 8 characters required".tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: '',
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                FormLabel("Re-Enter Password :".tr),
                TextFormField(
                  controller: confirmPasswordController,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Please enter new password".tr;
                    }
                    if(value != newPasswordController.text){
                      return "Confirm password does not match".tr;
                    }
                    if(value.length < 8){
                      return "Minimum 8 characters required".tr;
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                    const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
                    hintText: '',
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                CustomSpacer.l(),
                CustomElevatedButton(
                    onPressed: () {
                      print(oldPasswordController.text);
                      userController.updatePassword(
                          oldPassword: oldPasswordController.text,
                          newPassword: newPasswordController.text,
                          confirmPassword: confirmPasswordController.text,
                          user: userController.user!,
                      );
                    },
                    child: Text("Submit".tr))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
