import 'package:flutter/material.dart';

class CheckDisplay extends StatelessWidget {
  const CheckDisplay({super.key, required this.display, required this.child});
  final bool display;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return display ? child : const SizedBox();
  }
}