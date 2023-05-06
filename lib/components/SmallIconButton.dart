import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmt_/constants/colors.dart';

class SmallIconButton extends StatelessWidget {
  const SmallIconButton({Key? key, required this.onTap, required this.icon}) : super(key: key);
  final onTap;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: 40,
          width: 50,
          decoration: BoxDecoration(
            color: MYcolors.greycolor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon,
            size: 20,
          )),
    );
  }
}
