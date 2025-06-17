import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleConst {
  TextStyle headingStyle(
      {TextStyle textStyle = const TextStyle(),
      required Color color,
      required double size}) {
    return GoogleFonts.bebasNeue(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.bold,
      textStyle: textStyle,
    );
  }

  TextStyle regularStyle(
      {TextStyle textStyle = const TextStyle(),
      required Color color,
      required double size}) {
    return GoogleFonts.bebasNeue(
      color: color,
      fontSize: size,
      fontWeight: FontWeight.normal,
      textStyle: textStyle,
    );
  }
}
