// Indigo theme: colors, text styles, ThemeData, toast() and confirm().
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Set to false to use the phone's default font instead of Manrope.
const kUseManrope = true;

const kBg = Color(0xFFEFEEFF);
const kInk = Color(0xFF1E1B4B);
const kMuted = Color(0xFF55527F);
const kPrimary = Color(0xFF4F46E5);
const kDeep = Color(0xFF3730A3);
const kLink = Color(0xFF4338CA);
const kBorder = Color(0xFFD8D5FA);
const kChip = Color(0xFFE0DEFF);
const kDivider = Color(0xFFE8E6FA);
const kBlobA = Color(0xFFDAD7FF);
const kBlobB = Color(0xFFC4BFFF);
const kSoft = Color(0xFFD9D6FF);
const kGreen = Color(0xFF14683F), kGreenBg = Color(0xFFDDF5E8);
const kAmber = Color(0xFF7A5200), kAmberBg = Color(0xFFFFF1CF);
const kRed = Color(0xFF9A2F20), kRedBg = Color(0xFFFDE2E0);
const kGreyBg = Color(0xFFE8E7F4);
const kDotGreen = Color(0xFF2E9E6B), kDotRed = Color(0xFFD9483B);
const kAmberBar = Color(0xFFE8A317), kIndigo500 = Color(0xFF6366F1);
const kCyan = Color(0xFF5CC8FF), kYellow = Color(0xFFFFD27A);

const kShadow = [BoxShadow(color: Color(0x121E1B4B), blurRadius: 14, offset: Offset(0, 4))];
const kShadowDeep = [BoxShadow(color: Color(0x593730A3), blurRadius: 32, offset: Offset(0, 16))];

const kH1 = TextStyle(fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: -1, color: kInk, height: 1.1);
const kSub = TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: kMuted);
const kRowTitle = TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: kInk);
const kRowSub = TextStyle(fontSize: 13, color: kMuted);
const kSection = TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kMuted);
const kNote = TextStyle(fontSize: 13, color: kMuted, height: 1.5);

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimary, primary: kPrimary, surface: kBg),
    scaffoldBackgroundColor: kBg,
  );
  final text = base.textTheme.apply(bodyColor: kInk, displayColor: kInk);
  OutlineInputBorder ob(Color c) => OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: c, width: 2));
  return base.copyWith(
    textTheme: kUseManrope ? GoogleFonts.manropeTextTheme(text) : text,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      border: ob(kBorder),
      enabledBorder: ob(kBorder),
      focusedBorder: ob(kPrimary),
      errorBorder: ob(kDotRed),
      focusedErrorBorder: ob(kDotRed),
    ),
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      backgroundColor: kInk,
      contentTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
    ),
  );
}

void toast(BuildContext c, String m) => ScaffoldMessenger.of(c)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(m)));

Future<bool> confirm(BuildContext c, String title, String body, {String yes = 'Confirm', bool danger = false}) async {
  final r = await showDialog<bool>(
    context: c,
    builder: (d) => AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d, false), child: const Text('Cancel')),
        TextButton(
          onPressed: () => Navigator.pop(d, true),
          child: Text(yes, style: TextStyle(color: danger ? kRed : kPrimary, fontWeight: FontWeight.w800)),
        ),
      ],
    ),
  );
  return r == true;
}
