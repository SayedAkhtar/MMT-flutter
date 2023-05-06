import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mmt_/helper/CustomSpacer.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({Key? key, required this.onPressed, required this.child, this.isActive}) : super(key: key);

  final VoidCallback onPressed;
  final Widget child;
  final bool? isActive;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CustomSpacer.L))
      ),
      child: child
    );
  }
}
