import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

SizedBox gap(double h) => SizedBox(height: h);
SizedBox hgap(double w) => SizedBox(width: w);

/// White rounded surface used across the app.
class EtCard extends StatelessWidget {
  const EtCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(20),
    this.radius = 24,
    this.color = Colors.white,
    this.shadow = AppShadows.card,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final double radius;
  final Color color;
  final List<BoxShadow> shadow;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = Padding(padding: padding, child: child);
    final br = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration:
          BoxDecoration(color: color, borderRadius: br, boxShadow: shadow),
      child: onTap == null
          ? content
          : Material(
              color: Colors.transparent,
              borderRadius: br,
              clipBehavior: Clip.antiAlias,
              child: InkWell(onTap: onTap, child: content),
            ),
    );
  }
}

enum EtButtonStyle { primary, outline, outlineAccent, tonal, white }

class EtButton extends StatelessWidget {
  const EtButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.style = EtButtonStyle.primary,
    this.height = 60,
    this.radius = 14,
    this.fontSize = 15,
    this.shadow,
    this.loading = false,
    this.horizontalPadding = 0,
    this.customForeground,
    this.customBorder,
  });

  final String label;
  final VoidCallback? onPressed;
  final EtButtonStyle style;
  final double height;
  final double radius;
  final double fontSize;
  final List<BoxShadow>? shadow;
  final bool loading;
  final double horizontalPadding;
  final Color? customForeground;
  final Color? customBorder;

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    BorderSide side = BorderSide.none;
    switch (style) {
      case EtButtonStyle.primary:
        bg = AppColors.primary;
        fg = Colors.white;
        break;
      case EtButtonStyle.outline:
        bg = Colors.white;
        fg = AppColors.ink;
        side = const BorderSide(color: AppColors.border, width: 2);
        break;
      case EtButtonStyle.outlineAccent:
        bg = Colors.white;
        fg = AppColors.deep;
        side = const BorderSide(color: AppColors.blobSmall, width: 2);
        break;
      case EtButtonStyle.tonal:
        bg = AppColors.chip;
        fg = AppColors.deep;
        break;
      case EtButtonStyle.white:
        bg = Colors.white;
        fg = AppColors.deep;
        break;
    }
    if (customForeground != null) fg = customForeground!;
    if (customBorder != null) {
      side = BorderSide(color: customBorder!, width: 2);
    }
    final shape = RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius), side: side);
    final enabled = onPressed != null && !loading;

    return Opacity(
      opacity: onPressed == null && !loading ? 0.5 : 1,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: shadow,
        ),
        child: Material(
          color: bg,
          shape: shape,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: enabled ? onPressed : null,
            customBorder: shape,
            child: SizedBox(
              height: height,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: Center(
                  child: loading
                      ? SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.6, color: fg),
                        )
                      : Text(
                          label,
                          textAlign: TextAlign.center,
                          style: AppText.style(fontSize, FontWeight.w800, fg),
                        ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Labelled text field: 2px border, 16px radius, Manrope.
class EtTextField extends StatelessWidget {
  const EtTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscure = false,
    this.keyboardType,
    this.inputFormatters,
    this.weight = FontWeight.w600,
    this.letterSpacingEm,
    this.height = 60,
    this.labelGap = 5,
    this.error,
    this.onChanged,
    this.textInputAction,
    this.onSubmitted,
  });

  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final FontWeight weight;
  final double? letterSpacingEm;
  final double height;
  final double labelGap;
  final String? error;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onSubmitted;

  OutlineInputBorder _border(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: c, width: 2),
      );

  @override
  Widget build(BuildContext context) {
    final hasError = error != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(label,
              style: AppText.style(13, FontWeight.w700, AppColors.ink)),
        ),
        gap(labelGap),
        SizedBox(
          height: height,
          child: TextField(
            controller: controller,
            obscureText: obscure,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            textInputAction: textInputAction,
            onSubmitted: onSubmitted,
            textAlignVertical: TextAlignVertical.center,
            cursorColor: AppColors.primary,
            style: AppText.style(16, weight, AppColors.ink,
                ls: letterSpacingEm),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 18),
              enabledBorder:
                  _border(hasError ? AppColors.redFg : AppColors.border),
              focusedBorder: _border(
                  hasError ? AppColors.redFg : AppColors.primary),
              border: _border(AppColors.border),
            ),
          ),
        ),
        if (hasError) ...[
          gap(5),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(error!,
                style: AppText.style(12, FontWeight.w600, AppColors.redFg)),
          ),
        ],
      ],
    );
  }
}

/// White segmented control (role switcher, filter tabs).
class EtSegmented extends StatelessWidget {
  const EtSegmented({
    super.key,
    required this.labels,
    required this.selected,
    required this.onChanged,
  });

  final List<String> labels;
  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++) ...[
            if (i > 0) hgap(4),
            Expanded(
              child: Material(
                color: i == selected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => onChanged(i),
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        labels[i],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppText.style(
                          14,
                          i == selected ? FontWeight.w700 : FontWeight.w600,
                          i == selected ? Colors.white : AppColors.muted,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Small rounded status label.
class EtPill extends StatelessWidget {
  const EtPill(
    this.text, {
    super.key,
    required this.bg,
    required this.fg,
    this.fontSize = 12,
    this.weight = FontWeight.w800,
    this.padding = const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  });

  final String text;
  final Color bg;
  final Color fg;
  final double fontSize;
  final FontWeight weight;
  final EdgeInsets padding;

  factory EtPill.presentPill({Key? key}) =>
      EtPill('Present', key: key, bg: AppColors.greenBg, fg: AppColors.greenFg);
  factory EtPill.latePill({Key? key}) =>
      EtPill('Late', key: key, bg: AppColors.amberBg, fg: AppColors.amberFg);
  factory EtPill.absentPill({Key? key}) =>
      EtPill('Absent', key: key, bg: AppColors.redBg, fg: AppColors.redFg);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration:
          BoxDecoration(color: bg, borderRadius: BorderRadius.circular(10)),
      child: Text(text, style: AppText.style(fontSize, weight, fg)),
    );
  }
}

/// "← Rooms" style back link.
class EtBackLink extends StatelessWidget {
  const EtBackLink(this.label, {super.key, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap ?? () => Navigator.of(context).maybePop(),
        child: Text(label,
            style: AppText.style(14, FontWeight.w700, AppColors.link)),
      ),
    );
  }
}

/// Muted section heading such as "Later today".
class EtSectionLabel extends StatelessWidget {
  const EtSectionLabel(this.text, {super.key, this.leftPadding = 0});

  final String text;
  final double leftPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: leftPadding),
      child: Text(text, style: AppText.sectionLabel()),
    );
  }
}

/// A white card holding rows separated by hairlines.
class EtRowList extends StatelessWidget {
  const EtRowList({super.key, required this.rows, this.emptyText});

  final List<Widget> rows;
  final String? emptyText;

  @override
  Widget build(BuildContext context) {
    return EtCard(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: rows.isEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  emptyText ?? 'Nothing here yet.',
                  textAlign: TextAlign.center,
                  style: AppText.style(14, FontWeight.w600, AppColors.muted),
                ),
              ),
            )
          : Column(
              children: [
                for (var i = 0; i < rows.length; i++)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      border: i == rows.length - 1
                          ? null
                          : const Border(
                              bottom: BorderSide(color: AppColors.divider)),
                    ),
                    child: rows[i],
                  ),
              ],
            ),
    );
  }
}

/// Footnote / helper paragraph.
class EtNote extends StatelessWidget {
  const EtNote(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: AppText.style(13, FontWeight.w400, AppColors.muted,
            height: 1.5),
      );
}

void showEtSnack(
  BuildContext context,
  String message, {
  String? actionLabel,
  VoidCallback? onAction,
}) {
  final m = ScaffoldMessenger.of(context);
  m.hideCurrentSnackBar();
  m.showSnackBar(
    SnackBar(
      content: Text(message),
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 96),
      duration: const Duration(seconds: 3),
      action: actionLabel == null
          ? null
          : SnackBarAction(label: actionLabel, onPressed: onAction ?? () {}),
    ),
  );
}


/// Pill-shaped on/off switch (48x28) from the design.
class EtSwitch extends StatelessWidget {
  const EtSwitch({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      toggled: value,
      child: GestureDetector(
        onTap: () => onChanged(!value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 48,
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(
            color: value ? AppColors.primary : AppColors.border,
            borderRadius: BorderRadius.circular(99),
          ),
          child: Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Horizontal progress bar (10px, rounded) used for attendance percentages.
class EtBar extends StatelessWidget {
  const EtBar({
    super.key,
    required this.fraction,
    this.track = AppColors.chip,
    this.fill = AppColors.indigoBar,
  });

  final double fraction;
  final Color track;
  final Color fill;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      decoration:
          BoxDecoration(color: track, borderRadius: BorderRadius.circular(6)),
      alignment: Alignment.centerLeft,
      child: FractionallySizedBox(
        widthFactor: fraction.clamp(0.0, 1.0).toDouble(),
        child: Container(
          height: 10,
          decoration: BoxDecoration(
              color: fill, borderRadius: BorderRadius.circular(6)),
        ),
      ),
    );
  }
}
