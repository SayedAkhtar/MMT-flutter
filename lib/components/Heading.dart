import 'package:flutter/cupertino.dart';
import 'package:mmt_/components/TranslatedText.dart';

class Heading extends StatelessWidget {
  const Heading({Key? key, required this.heading}) : super(key: key);
  final String heading;
  @override
  Widget build(BuildContext context) {
    return TranslatedText(
      text: heading,
      style: const TextStyle(fontFamily: "Brandon", fontSize: 20),
    );
  }
}
