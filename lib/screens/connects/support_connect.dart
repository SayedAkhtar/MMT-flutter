import 'package:MyMedTrip/controller/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tawk/flutter_tawk.dart';
import 'package:get/get.dart';

class SupportConnect extends GetView<UserController> {
  const SupportConnect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("MMT Support Chat"),),
      body: Tawk(
        directChatLink: 'https://tawk.to/chat/61408ec9d326717cb6816277/1ffi2rhte',
        visitor: TawkVisitor(
            name: controller.user?.name ?? "Guest",
            email: controller.user?.phoneNo ?? "",
        ),
      ),
    );
  }
}
