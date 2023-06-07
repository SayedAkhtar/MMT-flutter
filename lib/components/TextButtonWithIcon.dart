import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:MyMedTrip/components/TranslatedText.dart';
import 'package:MyMedTrip/constants/colors.dart';

class TextButtonWithIcon extends StatelessWidget {
  TextButtonWithIcon({
    Key? key,
    required this.onPressed,
    required this.icon,
    required this.text,
    this.iconAtStart = false,
    this.style,
  }) : super(key: key);
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  bool iconAtStart;
  ButtonStyle? style;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        child: Row(
          textDirection: iconAtStart ? TextDirection.ltr : TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: MYcolors.blackcolor,
            ),
            TranslatedText(
              text: text,
              style: const TextStyle(color: MYcolors.blackcolor),
            )
          ],
        ));
  }
}
