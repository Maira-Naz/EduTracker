import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Manrope text styles. [ls] is letter-spacing in em, like the design's CSS.
class AppText {
  AppText._();

  static TextStyle style(
    double size,
    FontWeight weight,
    Color color, {
    double? ls,
    double? height,
  }) {
    return GoogleFonts.manrope(
      fontSize: size,
      fontWeight: weight,
      color: color,
      letterSpacing: ls == null ? null : size * ls,
      height: height,
    );
  }

  static TextStyle h1([double size = 34]) =>
      style(size, FontWeight.w800, AppColors.ink, ls: -0.03);

  static TextStyle sectionLabel() =>
      style(14, FontWeight.w700, AppColors.muted);
}
