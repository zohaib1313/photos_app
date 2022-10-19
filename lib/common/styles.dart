import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColor {
  static var primaryColor = Color(0xff014493);
  static var primaryBlueDarkColor = Color(0xff0070cc);
  static var blackColor = Color(0xff1C2340);
  static var greenColor = Color(0xff2CC78C);
  static var redColor = Colors.red;
  static var alphaGrey = Color(0xffe3e2e2);
  static var whiteColor = Colors.white;
  static var greyColor = Colors.grey;
  static var yellowColor = Color(0xffFFC107);
}

class AppTextStyles {
  static final _fontBold =
      GoogleFonts.abel(textStyle: TextStyle(fontWeight: FontWeight.bold));
  static final _fontNormal =
      GoogleFonts.abel(textStyle: TextStyle(fontWeight: FontWeight.normal));

  static TextStyle textStyleBoldTitleLarge = _fontBold.copyWith(fontSize: 22);

  static TextStyle textStyleBoldSubTitleLarge =
      _fontBold.copyWith(fontSize: 20);

  static TextStyle textStyleNormalLargeTitle =
      _fontNormal.copyWith(fontSize: 20);
  static TextStyle textStyleBoldBodyMedium = _fontBold.copyWith(fontSize: 16);
  static TextStyle textStyleNormalBodyMedium =
      _fontNormal.copyWith(fontSize: 16);
  static TextStyle textStyleBoldBodySmall = _fontBold.copyWith(fontSize: 14);
  static TextStyle textStyleNormalBodySmall =
      _fontNormal.copyWith(fontSize: 14);
  static TextStyle textStyleBoldBodyXSmall = _fontBold.copyWith(fontSize: 12);
  static TextStyle textStyleNormalBodyXSmall =
      _fontNormal.copyWith(fontSize: 12);
}
