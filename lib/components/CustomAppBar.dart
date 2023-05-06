import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mmt_/constants/colors.dart';

import 'BackButton.dart';
import 'SmallIconButton.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String pageName;
  bool? showDivider = false;
  bool showBack = true;
  CustomAppBar({
    this.height = kToolbarHeight,
    required this.pageName,
    this.showDivider,
    this.showBack = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: (showDivider == true)?MYcolors.blackcolor.withOpacity(0.2):Colors.transparent))
      ),
      padding: const EdgeInsets.only(left: 16.6, right: 16.0),
      child: Row(
        children: [
          showBack?SmallIconButton(
              onTap: () {
                Get.back();
              },
              icon: Icons.arrow_back_ios_new_outlined
          ):SizedBox(),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.02,
          ),
          Text(
            pageName.tr,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              // fontFamily: "Brandon",
              fontSize: 25,
            ),
          )
        ],
      ),
    );
  }
}
