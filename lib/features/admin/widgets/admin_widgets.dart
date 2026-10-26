import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text.dart';

const kPad = EdgeInsets.symmetric(horizontal: 20);

void toast(BuildContext c, String msg) {
  ScaffoldMessenger.of(c)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(msg)));
}

class Header extends StatelessWidget {
  const Header({
    super.key,
    required this.title,
    this.eyebrow,
    this.back,
    this.sub,
    this.trailing,
  });
  final String title;
  final String? eyebrow, back, sub;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (back != null)
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10, top: 4),
            child: Text('← $back',
                style: AppText.style(12, FontWeight.w700, AppColors.link)),
          ),
        ),
      if (eyebrow != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(eyebrow!,
              style: AppText.style(12, FontWeight.w600, AppColors.muted)),
        ),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Expanded(child: Text(title, style: AppText.h1(30))),
        if (trailing != null) trailing!,
      ]),
      if (sub != null)
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(sub!,
              style: AppText.style(12, FontWeight.w600, AppColors.muted)),
        ),
    ]);
  }
}

class Pill extends StatelessWidget {
  const Pill(this.text, this.bg, this.fg, {super.key});
  final String text;
  final Color bg, fg;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
        child: Text(text, style: AppText.style(11, FontWeight.w800, fg)),
      );
}

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.color});
  final Widget child;
  final VoidCallback? onTap;
  final Color? color;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Material(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: AppShadows.card),
              child: child,
            ),
          ),
        ),
      );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton(this.label, this.onTap, {super.key, this.shadow = true});
  final String label;
  final VoidCallback onTap;
  final bool shadow;
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: shadow ? AppShadows.primarySmall : null),
        child: Material(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: onTap,
            child: Container(
              height: 56,
              alignment: Alignment.center,
              child: Text(label,
                  style: AppText.style(14, FontWeight.w800, Colors.white)),
            ),
          ),
        ),
      );
}

class OutlineBtn extends StatelessWidget {
  const OutlineBtn(this.label, this.onTap,
      {super.key, this.color, this.border});
  final String label;
  final VoidCallback onTap;
  final Color? color, border;
  @override
  Widget build(BuildContext context) => Material(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Container(
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: border ?? AppColors.border, width: 1.5),
            ),
            child: Text(label,
                style: AppText.style(
                    14, FontWeight.w800, color ?? AppColors.ink)),
          ),
        ),
      );
}

class Segmented extends StatelessWidget {
  const Segmented(
      {super.key,
      required this.labels,
      required this.index,
      required this.onChanged});
  final List<String> labels;
  final int index;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: AppShadows.card),
        child: Row(
          children: [
            for (var n = 0; n < labels.length; n++)
              Expanded(
                child: GestureDetector(
                  onTap: () => onChanged(n),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: n == index ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(labels[n],
                        style: AppText.style(
                            12,
                            FontWeight.w800,
                            n == index ? Colors.white : AppColors.deep)),
                  ),
                ),
              ),
          ],
        ),
      );
}

class Field extends StatelessWidget {
  const Field(
    this.label, {
    super.key,
    this.controller,
    this.value,
    this.onTap,
    this.obscure = false,
    this.keyboard,
  });
  final String label;
  final TextEditingController? controller;
  final String? value; // read-only picker mode when onTap != null
  final VoidCallback? onTap;
  final bool obscure;
  final TextInputType? keyboard;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.border, width: 1.5),
    );
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(label,
            style: AppText.style(11, FontWeight.w700, AppColors.ink)),
      ),
      TextField(
        controller: onTap != null
            ? (TextEditingController(text: value))
            : controller,
        readOnly: onTap != null,
        onTap: onTap,
        obscureText: obscure,
        keyboardType: keyboard,
        style: AppText.style(13, FontWeight.w600, AppColors.ink),
        decoration: InputDecoration(
          isDense: true,
          filled: true,
          fillColor: AppColors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
          border: border,
          enabledBorder: border,
          focusedBorder: border.copyWith(
              borderSide:
                  const BorderSide(color: AppColors.primary, width: 1.5)),
        ),
      ),
    ]);
  }
}

Future<String?> pickOption(
    BuildContext context, String title, List<String> options) {
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
    builder: (_) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(title, style: AppText.style(16, FontWeight.w800, AppColors.ink)),
          const SizedBox(height: 8),
          for (final o in options)
            ListTile(
              title: Text(o,
                  style: AppText.style(14, FontWeight.w700, AppColors.ink)),
              onTap: () => Navigator.pop(context, o),
            ),
        ]),
      ),
    ),
  );
}

String fmt(TimeOfDay t) =>
    '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';

TimeOfDay parseTime(String s) {
  final p = s.split(':');
  return TimeOfDay(hour: int.parse(p[0]), minute: int.parse(p[1]));
}

/// AppPage scaffold: scrolling content with consistent padding.
class AppPage extends StatelessWidget {
  const AppPage({super.key, required this.children, this.bottom});
  final List<Widget> children;
  final List<Widget>? bottom;
  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.bg,
        body: SafeArea(
          bottom: false,
          child: ListView(
            padding: kPad.copyWith(top: 16, bottom: 24),
            children: [...children, ...?bottom],
          ),
        ),
      );
}
