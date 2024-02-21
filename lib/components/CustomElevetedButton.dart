import 'package:flutter/material.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({super.key, required this.onPressed, required this.child, this.isActive});

  final VoidCallback onPressed;
  final Widget child;
  final bool? isActive;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(CustomSpacer.L))
      ),
      child: child
    );
  }
}
