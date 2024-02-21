import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:get/get.dart';

class SupportConnect extends GetView<UserController> {
  const SupportConnect({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MMT Support Chat"),),
      body: Tawk(
        directChatLink: 'https://tawk.to/chat/603a25e11c1c2a130d63076d/1evhi7usq',
        visitor: TawkVisitor(
            name: controller.user?.name ?? "Guest".tr,
            email: controller.user?.phoneNo ?? "",
        ),
      ),
    );
  }
}
