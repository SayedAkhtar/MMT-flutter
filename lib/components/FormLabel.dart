import 'package:flutter/cupertino.dart';
import 'package:mmt_/components/TranslatedText.dart';

class FormLabel extends StatelessWidget {
  const FormLabel(this.label, {Key? key}) : super(key: key);
  final String label;
  @override
  Widget build(BuildContext context) {
    return TranslatedText(
      text: label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    );
  }
}
