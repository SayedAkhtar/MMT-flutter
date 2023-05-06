import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StyledTextFormField extends StatelessWidget {
  const StyledTextFormField({Key? key, this.controller, this.initialValue}) : super(key: key);
  final TextEditingController? controller;
  final String? initialValue;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: controller != null ? controller!.text : (initialValue ?? ''),
      onSaved: (value){},
      decoration: InputDecoration(
        contentPadding:
        const EdgeInsets.only(left: 15, bottom: 11, top: 11, right: 15),
        hintText: "Name",
        border:
        OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
