// Colors, text styles, app theme, and small helpers (toast, confirm dialog).
import 'package:flutter/material.dart';

const kBg = Color(0xFFF5F6FB);
const kInk = Color(0xFF14142B);
const kMuted = Color(0xFF5B5F7A);
const kPrimary = Color(0xFF3D4DFF);
const kLine = Color(0xFFE3E5F0);
const kGreen = Color(0xFF0B6B43), kGreenBg = Color(0xFFDDF5E8);
const kRed = Color(0xFFA3211A), kRedBg = Color(0xFFFDE4E1);
const kAmber = Color(0xFF7A4A00), kAmberBg = Color(0xFFFFEBC2);
const kViolet = Color(0xFF2B38D6), kVioletBg = Color(0xFFE6E8FF);
const kGrey = Color(0xFFE6E8F5);

const kH1 = TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: kInk, letterSpacing: -0.5, height: 1.15);
const kH3 = TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: kInk);
const kMut = TextStyle(fontSize: 13, color: kMuted, height: 1.4);

enum Tone { green, red, amber, violet, grey }

Color toneFg(Tone t) => switch (t) {
      Tone.green => kGreen,
      Tone.red => kRed,
      Tone.amber => kAmber,
      Tone.violet => kViolet,
      Tone.grey => kMuted,
    };

Color toneBg(Tone t) => switch (t) {
      Tone.green => kGreenBg,
      Tone.red => kRedBg,
      Tone.amber => kAmberBg,
      Tone.violet => kVioletBg,
      Tone.grey => kGrey,
    };

Tone pctTone(num p) => p >= 80 ? Tone.green : (p >= 75 ? Tone.amber : Tone.red);
Color barColor(num p) => p >= 80 ? const Color(0xFF1F9D6B) : (p >= 75 ? const Color(0xFFC77700) : const Color(0xFFD92D20));

ThemeData buildTheme() {
  const line = Color(0xFFD5D8E8);
  OutlineInputBorder ob(Color c, [double w = 1]) =>
      OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: c, width: w));
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(14));
  const text = TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  return ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(seedColor: kPrimary, primary: kPrimary, surface: kBg),
    scaffoldBackgroundColor: kBg,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: ob(line),
      enabledBorder: ob(line),
      focusedBorder: ob(kPrimary, 2),
      errorBorder: ob(kRed),
      focusedErrorBorder: ob(kRed, 2),
    ),
    filledButtonTheme: FilledButtonThemeData(style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: shape, textStyle: text)),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52), foregroundColor: kInk, side: const BorderSide(color: line), shape: shape, textStyle: text)),
    navigationBarTheme: const NavigationBarThemeData(backgroundColor: Colors.white, indicatorColor: kVioletBg, height: 70),
    snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
  );
}

void toast(BuildContext c, String m) => ScaffoldMessenger.of(c)
  ..hideCurrentSnackBar()
  ..showSnackBar(SnackBar(content: Text(m)));

Future<bool> confirm(BuildContext c, String title, String body, {String yes = 'Confirm', bool danger = false}) async {
  final r = await showDialog<bool>(
    context: c,
    builder: (d) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(onPressed: () => Navigator.pop(d, false), child: const Text('Cancel')),
        TextButton(
            onPressed: () => Navigator.pop(d, true),
            child: Text(yes, style: TextStyle(color: danger ? kRed : kPrimary, fontWeight: FontWeight.w700))),
      ],
    ),
  );
  return r == true;
}
