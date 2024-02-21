import 'package:flutter/material.dart';
import 'package:MyMedTrip/helper/CustomSpacer.dart';

class MarginBox extends StatelessWidget {
  const MarginBox({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: CustomSpacer.XS),
      child: child,
    );
  }
}
