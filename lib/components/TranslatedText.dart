import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TranslatedText extends StatelessWidget {
  TranslatedText({Key? key, this.text = "Default Text", this.style }) : super(key: key);
  String? text;
  final TextStyle? style;
  @override
  Widget build(BuildContext context) {
    return Text(
      text != null ?text!.tr:"NO DATA",
      style: style?? const TextStyle(),
    );
  }
}
