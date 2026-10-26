import 'package:flutter/material.dart';

/// Colour tokens taken 1:1 from the EduTrack design file.
class AppColors {
  AppColors._();

  static const bg = Color(0xFFEFEEFF);
  static const ink = Color(0xFF1E1B4B);
  static const muted = Color(0xFF55527F);
  static const primary = Color(0xFF4F46E5);
  static const deep = Color(0xFF3730A3);
  static const link = Color(0xFF4338CA);
  static const border = Color(0xFFD8D5FA);
  static const divider = Color(0xFFE8E6FA);
  static const chip = Color(0xFFE0DEFF);
  static const blobLarge = Color(0xFFDAD7FF);
  static const blobSmall = Color(0xFFC4BFFF);
  static const onDeepMuted = Color(0xFFD9D6FF);
  static const avatarViolet = Color(0xFF7C3AED);
  static const closedBg = Color(0xFFE8E7F4);
  static const white = Colors.white;

  static const greenBg = Color(0xFFDDF5E8);
  static const greenFg = Color(0xFF14683F);
  static const amberBg = Color(0xFFFFF1CF);
  static const amberFg = Color(0xFF7A5200);
  static const amberBar = Color(0xFFE8A317);
  static const redBg = Color(0xFFFDE2E0);
  static const redFg = Color(0xFF9A2F20);
}

class AppShadows {
  AppShadows._();

  static const card = [
    BoxShadow(
        color: Color.fromRGBO(30, 27, 75, 0.07),
        offset: Offset(0, 4),
        blurRadius: 14),
  ];
  static const deepCard = [
    BoxShadow(
        color: Color.fromRGBO(55, 48, 163, 0.35),
        offset: Offset(0, 16),
        blurRadius: 32),
  ];
  static const primaryLarge = [
    BoxShadow(
        color: Color.fromRGBO(79, 70, 229, 0.32),
        offset: Offset(0, 12),
        blurRadius: 24),
  ];
  static const primarySmall = [
    BoxShadow(
        color: Color.fromRGBO(79, 70, 229, 0.28),
        offset: Offset(0, 10),
        blurRadius: 20),
  ];
  static const logo = [
    BoxShadow(
        color: Color.fromRGBO(79, 70, 229, 0.35),
        offset: Offset(0, 10),
        blurRadius: 24),
  ];
  static const navUp = [
    BoxShadow(
        color: Color.fromRGBO(30, 27, 75, 0.08),
        offset: Offset(0, -6),
        blurRadius: 20),
  ];
}
