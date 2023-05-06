import 'package:flutter/material.dart';

class MarginBox extends StatelessWidget {
  const MarginBox({Key? key, required this.child}) : super(key: key);
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16.0),
      child: child,
    );
  }
}
