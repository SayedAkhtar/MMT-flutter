import 'package:flutter/cupertino.dart';
import 'package:MyMedTrip/components/TranslatedText.dart';

class Heading extends StatelessWidget {
  const Heading({Key? key, required this.heading}) : super(key: key);
  final String heading;
  @override
  Widget build(BuildContext context) {
    return TranslatedText(
      text: heading,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
    );
  }
}
