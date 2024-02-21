import 'package:flutter/cupertino.dart';
import 'package:MyMedTrip/components/TranslatedText.dart';

class FormLabel extends StatelessWidget {
  const FormLabel(this.label, {super.key});
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
