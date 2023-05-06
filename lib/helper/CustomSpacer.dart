import 'package:flutter/cupertino.dart';

class CustomSpacer{
  static const double XS = 8;
  static const double S = 16;
  static const double M = 24;
  static const double L = 32;
  static Widget xs(){
    return const SizedBox(
      height: CustomSpacer.XS,
      width: CustomSpacer.XS,
    );
  }

  static Widget s(){
    return const SizedBox(
      height: CustomSpacer.S,
      width: CustomSpacer.S,
    );
  }
  static Widget m(){
    return const SizedBox(
      height: CustomSpacer.M,
      width: CustomSpacer.M,
    );
  }
  static Widget l(){
    return const SizedBox(
      height: CustomSpacer.L,
      width: CustomSpacer.L,
    );
  }
}