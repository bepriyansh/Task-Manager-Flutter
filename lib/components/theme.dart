import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const Color bluishColor = Color(0xFF3832F9);
const Color yellowColor = Color.fromARGB(255, 156, 188, 12);
const Color pinkColor = Color(0xFFC8000A);
const Color greyColor = Color(0xFF9E9E9E);
const Color darkGreyColor = Color(0xFF151515);
const Color whiteColor = Color(0xFFFFFFFF);
const Color blackColor = Color(0xFF000000);
const primaryColor = bluishColor;

class Themes {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      background: whiteColor,
    ),
    useMaterial3: true,
  );

  static final dark = ThemeData(
    colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        background: blackColor,
        brightness: Brightness.dark),
    useMaterial3: true,
  );
}

TextStyle get subHeadingStyle {
  return GoogleFonts.lato(
      textStyle: TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.grey[500],
  ));
}

TextStyle get headingStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w800,
  ));
}

TextStyle get titleStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
  ));
}

TextStyle get subTitleStyle {
  return GoogleFonts.lato(
      textStyle: const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
  ));
}
