import 'package:flutter/material.dart';
import 'package:MyMedTrip/components/TranslatedText.dart';
import 'package:MyMedTrip/constants/colors.dart';

class TextButtonWithIcon extends StatelessWidget {
  TextButtonWithIcon({
    super.key,
    required this.onPressed,
    this.icon,
    required this.text,
    this.iconAtStart = false,
    this.style,
    this.textStyle,
  });
  final VoidCallback onPressed;
  final IconData? icon;
  final String text;
  bool iconAtStart;
  ButtonStyle? style;
  TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Row(
          textDirection: iconAtStart ? TextDirection.ltr : TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon != null?
            Icon(
              icon,
              color: MYcolors.blackcolor,
            ):const SizedBox(),
            TranslatedText(
              text: text,
              style: textStyle ?? const TextStyle(color: MYcolors.blackcolor),
            )
          ],
        ));
  }
}
