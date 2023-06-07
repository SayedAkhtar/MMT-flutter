import 'package:MyMedTrip/components/CustomAppBar.dart';
import 'package:MyMedTrip/components/CustomElevetedButton.dart';
import 'package:MyMedTrip/components/FormLabel.dart';
import 'package:MyMedTrip/components/StyledTextFormField.dart';
import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
                const FormLabel("Old Password :"),
                TextFormField(
                  controller: oldPasswordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your old password';
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
                const FormLabel("New Password :"),
                TextFormField(
                  controller: newPasswordController,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Please enter new password";
                    }
                    if(value.length < 8){
                      return "Minimum 8 characters required";
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
                const FormLabel("Re-Enter Password :"),
                TextFormField(
                  controller: confirmPasswordController,
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return "Please enter new password";
                    }
                    if(value != newPasswordController.text){
                      return "Confirm password does not match";
                    }
                    if(value.length < 8){
                      return "Minimum 8 characters required";
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
                          confirmPassword: confirmPasswordController.text);
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
