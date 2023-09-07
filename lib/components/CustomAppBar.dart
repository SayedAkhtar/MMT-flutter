import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyMedTrip/constants/colors.dart';

import 'BackButton.dart';
import 'SmallIconButton.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String pageName;
  bool? showDivider = false;
  bool showBack = true;
  VoidCallback? backFunction;
  CustomAppBar({
    this.height = kToolbarHeight,
    required this.pageName,
    this.showDivider,
    this.showBack = true,
    this.backFunction,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: preferredSize.height,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: (showDivider == true)?MYcolors.blackcolor.withOpacity(0.2):Colors.transparent))
        ),
        padding: const EdgeInsets.only(left: 16.6, right: 16.0),
        child: Row(
          children: [
            showBack?SmallIconButton(
                onTap: backFunction?? () {
                  Get.back(closeOverlays: true);
                },
                icon: Icons.arrow_back_rounded

            ):SizedBox(),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.02,
            ),
            Text(
              pageName.tr,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                // fontFamily: "Brandon",
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}
