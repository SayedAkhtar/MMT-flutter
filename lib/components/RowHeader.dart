import 'package:MyMedTrip/components/Heading.dart';
import 'package:MyMedTrip/components/TextButtonWithIcon.dart';
import 'package:MyMedTrip/constants/colors.dart';
import 'package:MyMedTrip/theme/app_style.dart';
import 'package:flutter/material.dart';

class RowHeader extends StatelessWidget {
  const RowHeader({super.key, required this.heading, required this.action, this.text});
  final String heading;
  final VoidCallback action;
  final String? text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Heading(heading: heading),
        TextButtonWithIcon(
          onPressed: action,
          text: text ?? "See All",
          textStyle: AppStyle.txtRobotoRegular16.copyWith(
              color: MYcolors.bluecolor, decoration: TextDecoration.underline),
        ),
      ],
    );
  }
}