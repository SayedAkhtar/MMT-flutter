import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyMedTrip/components/SmallIconButton.dart';
import 'package:get/get.dart';

class BackButton extends StatelessWidget {
  const BackButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SmallIconButton(
        onTap: () {
          Get.back();
        },
        icon: Icons.arrow_back_ios_new_outlined
    );
  }
}
