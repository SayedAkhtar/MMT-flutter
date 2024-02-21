import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/size_utils.dart';

class AppDecoration {
  static BoxDecoration get outlineCyan600 => BoxDecoration(
    color: MYcolors.blueGray900,
    border: Border.all(
      color: MYcolors.cyan600,
      width: getHorizontalSize(
        3,
      ),
    ),
  );
  static BoxDecoration get fillGray900 => BoxDecoration(
    color: MYcolors.gray900,
  );
  static BoxDecoration get outlineCyan600011 => BoxDecoration(
    border: Border.all(
      color: MYcolors.cyan60001,
      width: getHorizontalSize(
        3,
      ),
    ),
  );
  static BoxDecoration get fillGray800 => BoxDecoration(
    color: MYcolors.gray800,
  );
  static BoxDecoration get outlineBlack90014 => BoxDecoration(
    color: MYcolors.blueGray900,
    boxShadow: [
      BoxShadow(
        color: MYcolors.black90014,
        spreadRadius: getHorizontalSize(
          2,
        ),
        blurRadius: getHorizontalSize(
          2,
        ),
        offset: const Offset(
          0,
          4,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineGray8002 => BoxDecoration(
    color: MYcolors.blueGray90001,
    border: Border.all(
      color: MYcolors.gray800,
      width: getHorizontalSize(
        1,
      ),
    ),
  );
  static BoxDecoration get outlineGray8001 => BoxDecoration(
    color: MYcolors.gray90001,
    border: Border.all(
      color: MYcolors.gray800,
      width: getHorizontalSize(
        1,
      ),
    ),
  );
  static BoxDecoration get fillWhiteA700 => const BoxDecoration(
    color: Colors.black87,
  );
  static BoxDecoration get fillBluegray900 => BoxDecoration(
    color: MYcolors.blueGray900,
  );
  static BoxDecoration get outlineGray800 => BoxDecoration(
    color: MYcolors.blueGray900,
    border: Border.all(
      color: MYcolors.gray800,
      width: getHorizontalSize(
        1,
      ),
    ),
  );
  static BoxDecoration get gradientGray80000Gray90096 => BoxDecoration(
    gradient: LinearGradient(
      begin: const Alignment(
        0.5,
        0,
      ),
      end: const Alignment(
        0.5,
        1,
      ),
      colors: [
        MYcolors.gray80000,
        MYcolors.blueGray90059,
        MYcolors.gray90096,
      ],
    ),
  );
  static BoxDecoration get txtFillCyan60001 => BoxDecoration(
    color: MYcolors.cyan60001,
  );
  static BoxDecoration get txtOutlineCyan60001 => BoxDecoration(
    border: Border.all(
      color: MYcolors.cyan60001,
      width: getHorizontalSize(
        2,
      ),
    ),
  );
  static BoxDecoration get fillCyan60001 => BoxDecoration(
    color: MYcolors.cyan60001,
  );
  static BoxDecoration get gradientGray80000Gray90002 => BoxDecoration(
    gradient: LinearGradient(
      begin: const Alignment(
        0.5,
        -0.78,
      ),
      end: const Alignment(
        0.5,
        1,
      ),
      colors: [
        MYcolors.gray80000,
        MYcolors.gray90002,
      ],
    ),
  );
  static BoxDecoration get outlineIndigoA20014 => BoxDecoration(
    color: MYcolors.teal900,
    boxShadow: [
      BoxShadow(
        color: MYcolors.indigoA20014,
        spreadRadius: getHorizontalSize(
          2,
        ),
        blurRadius: getHorizontalSize(
          2,
        ),
        offset: const Offset(
          0,
          0,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineBlack9000c => BoxDecoration(
    color: MYcolors.blueGray900,
    boxShadow: [
      BoxShadow(
        color: MYcolors.black9000c,
        spreadRadius: getHorizontalSize(
          2,
        ),
        blurRadius: getHorizontalSize(
          2,
        ),
        offset: const Offset(
          0,
          4,
        ),
      ),
    ],
  );
  static BoxDecoration get outlineCyan60001 => BoxDecoration(
    border: Border.all(
      color: MYcolors.cyan60001,
      width: getHorizontalSize(
        2,
      ),
    ),
  );
}

class BorderRadiusStyle {
  static BorderRadius roundedBorder16 = BorderRadius.circular(
    getHorizontalSize(
      16,
    ),
  );

  static BorderRadius customBorderBL36 = BorderRadius.only(
    bottomLeft: Radius.circular(
      getHorizontalSize(
        36,
      ),
    ),
    bottomRight: Radius.circular(
      getHorizontalSize(
        36,
      ),
    ),
  );

  static BorderRadius roundedBorder36 = BorderRadius.circular(
    getHorizontalSize(
      36,
    ),
  );

  static BorderRadius customBorderTL40 = BorderRadius.only(
    topLeft: Radius.circular(
      getHorizontalSize(
        40,
      ),
    ),
    topRight: Radius.circular(
      getHorizontalSize(
        40,
      ),
    ),
  );

  static BorderRadius txtCircleBorder19 = BorderRadius.circular(
    getHorizontalSize(
      19,
    ),
  );

  static BorderRadius circleBorder40 = BorderRadius.circular(
    getHorizontalSize(
      40,
    ),
  );

  static BorderRadius roundedBorder12 = BorderRadius.circular(
    getHorizontalSize(
      12,
    ),
  );

  static BorderRadius roundedBorder4 = BorderRadius.circular(
    getHorizontalSize(
      4,
    ),
  );

  static BorderRadius roundedBorder24 = BorderRadius.circular(
    getHorizontalSize(
      24,
    ),
  );

  static BorderRadius circleBorder70 = BorderRadius.circular(
    getHorizontalSize(
      70,
    ),
  );

  static BorderRadius roundedBorder20 = BorderRadius.circular(
    getHorizontalSize(
      20,
    ),
  );

  static BorderRadius circleBorder60 = BorderRadius.circular(
    getHorizontalSize(
      60,
    ),
  );
}

// Comment/Uncomment the below code based on your Flutter SDK version.

// For Flutter SDK Version 3.7.2 or greater.

double get strokeAlignInside => BorderSide.strokeAlignInside;

double get strokeAlignCenter => BorderSide.strokeAlignCenter;

double get strokeAlignOutside => BorderSide.strokeAlignOutside;

// For Flutter SDK Version 3.7.1 or less.

// StrokeAlign get strokeAlignInside => StrokeAlign.inside;
//
// StrokeAlign get strokeAlignCenter => StrokeAlign.center;
//
// StrokeAlign get strokeAlignOutside => StrokeAlign.outside;
