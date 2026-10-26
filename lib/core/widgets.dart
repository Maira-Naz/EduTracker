// Reusable building blocks for the Indigo design: Screen, Panel, Pill, buttons,
// segmented control, chips, avatar, and the bottom-tab shell (AppShell).
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';

/// Opens [w] inside the current tab (bottom tabs stay visible).
void go(BuildContext c, Widget w) => Navigator.of(c).push(MaterialPageRoute(builder: (_) => w));

/// Opens [w] full screen, above the bottom tabs.
void goRoot(BuildContext c, Widget w) => Navigator.of(c, rootNavigator: true).push(MaterialPageRoute(builder: (_) => w));

/// Standard page: optional back link, title (+ small text above or below), content.
class Screen extends StatelessWidget {
  const Screen({super.key, required this.title, required this.children, this.above, this.below, this.backLabel, this.trailing, this.gap = 14, this.titleSize});
  final String title;
  final String? above, below, backLabel;
  final Widget? trailing;
  final List<Widget> children;
  final double gap;
  final double? titleSize;

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: kBg,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            children: [
              if (backLabel != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => Navigator.maybePop(context),
                    child: Text('← $backLabel', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: kLink)),
                  ),
                ),
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    if (above != null) Padding(padding: const EdgeInsets.only(bottom: 2), child: Text(above!, style: kSub)),
                    Text(title, style: titleSize == null ? kH1 : kH1.copyWith(fontSize: titleSize)),
                    if (below != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(below!, style: kSub)),
                  ]),
                ),
                if (trailing != null) trailing!,
              ]),
              for (final w in children) Padding(padding: EdgeInsets.only(top: gap), child: w),
            ],
          ),
        ),
      );
}

class Panel extends StatelessWidget {
  const Panel({super.key, required this.child, this.onTap, this.color = Colors.white, this.radius = 22, this.padding = const EdgeInsets.all(18), this.border, this.shadow = true});
  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final double radius;
  final EdgeInsets padding;
  final BoxBorder? border;
  final bool shadow;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(radius), border: border, boxShadow: shadow ? kShadow : null),
        child: Material(
          color: Colors.transparent,
          child: InkWell(borderRadius: BorderRadius.circular(radius), onTap: onTap, child: Padding(padding: padding, child: SizedBox(width: double.infinity, child: child))),
        ),
      );
}

/// White panel with dividers between rows.
class RowsPanel extends StatelessWidget {
  const RowsPanel(this.rows, {super.key, this.empty = 'Nothing here yet.'});
  final List<Widget> rows;
  final String empty;
  @override
  Widget build(BuildContext context) => Panel(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
        child: rows.isEmpty
            ? Padding(padding: const EdgeInsets.symmetric(vertical: 18), child: Text(empty, textAlign: TextAlign.center, style: kRowSub))
            : Column(children: [
                for (var i = 0; i < rows.length; i++) ...[if (i > 0) const Divider(height: 1, thickness: 1, color: kDivider), rows[i]],
              ]),
      );
}

class RowItem extends StatelessWidget {
  const RowItem(this.title, {super.key, this.sub, this.leading, this.trailing, this.onTap});
  final String title;
  final String? sub;
  final Widget? leading, trailing;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13),
          child: Row(children: [
            if (leading != null) ...[leading!, const SizedBox(width: 12)],
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(title, style: kRowTitle),
                if (sub != null) Text(sub!, style: kRowSub),
              ]),
            ),
            if (trailing != null) ...[const SizedBox(width: 12), trailing!],
          ]),
        ),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(left: 2, top: 4), child: Text(text, style: kSection));
}

enum Tone { green, red, amber, indigo, grey }

Color toneFg(Tone t) => switch (t) { Tone.green => kGreen, Tone.red => kRed, Tone.amber => kAmber, Tone.indigo => kDeep, Tone.grey => kMuted };
Color toneBg(Tone t) => switch (t) { Tone.green => kGreenBg, Tone.red => kRedBg, Tone.amber => kAmberBg, Tone.indigo => kChip, Tone.grey => kGreyBg };

class Pill extends StatelessWidget {
  const Pill(this.text, this.tone, {super.key, this.dot = false, this.size = 12});
  final String text;
  final Tone tone;
  final bool dot;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(color: toneBg(tone), borderRadius: BorderRadius.circular(10)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          if (dot) Container(width: 7, height: 7, margin: const EdgeInsets.only(right: 6), decoration: BoxDecoration(color: toneFg(tone), shape: BoxShape.circle)),
          Text(text, style: TextStyle(fontSize: size, fontWeight: FontWeight.w800, color: toneFg(tone))),
        ]),
      );
}

/// Percentage shown as plain text when healthy, as a colored pill when low.
Widget pctBadge(num p) => p >= 75
    ? Text('${p.round()}%', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: kLink))
    : Pill('${p.round()}%', p < 70 ? Tone.red : Tone.amber, size: 13);

Color barColor(num p) => p >= 75 ? kIndigo500 : (p >= 70 ? kAmberBar : kDotRed);

class Bar extends StatelessWidget {
  const Bar(this.pct, {super.key, this.color, this.height = 8});
  final num pct;
  final Color? color;
  final double height;
  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(6),
        child: LinearProgressIndicator(value: (pct / 100).clamp(0, 1).toDouble(), minHeight: height, backgroundColor: kChip, valueColor: AlwaysStoppedAnimation(color ?? barColor(pct))),
      );
}

class HeroCard extends StatelessWidget {
  const HeroCard({super.key, required this.child, this.radius = 26, this.padding = const EdgeInsets.all(22)});
  final Widget child;
  final double radius;
  final EdgeInsets padding;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: padding,
        decoration: BoxDecoration(color: kDeep, borderRadius: BorderRadius.circular(radius), boxShadow: kShadowDeep),
        child: child,
      );
}

class StatCard extends StatelessWidget {
  const StatCard(this.value, this.label, {super.key, this.onTap, this.valueSize = 24});
  final String value, label;
  final VoidCallback? onTap;
  final double valueSize;
  @override
  Widget build(BuildContext context) => Panel(
        radius: 18,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        onTap: onTap,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
          Text(value, style: TextStyle(fontSize: valueSize, fontWeight: FontWeight.w800)),
          Text(label, style: const TextStyle(fontSize: 12, color: kMuted)),
        ]),
      );
}

Widget statRow(List<Widget> t) => IntrinsicHeight(
      child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        for (var i = 0; i < t.length; i++) ...[if (i > 0) const SizedBox(width: 10), Expanded(child: t[i])],
      ]),
    );

class PButton extends StatelessWidget {
  const PButton(this.text, this.onTap, {super.key, this.height = 56, this.size = 16});
  final String text;
  final VoidCallback? onTap;
  final double height, size;
  @override
  Widget build(BuildContext context) => Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Container(
          height: height,
          decoration: BoxDecoration(color: kPrimary, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Color(0x524F46E5), blurRadius: 24, offset: Offset(0, 12))]),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: onTap,
              child: Center(child: Text(text, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size))),
            ),
          ),
        ),
      );
}

class OButton extends StatelessWidget {
  const OButton(this.text, this.onTap, {super.key, this.height = 54, this.size = 15, this.border = kBorder, this.color = kInk});
  final String text;
  final VoidCallback? onTap;
  final double height, size;
  final Color border, color;
  @override
  Widget build(BuildContext context) => Opacity(
        opacity: onTap == null ? 0.5 : 1,
        child: Container(
          height: height,
          decoration: BoxDecoration(color: Colors.white, border: Border.all(color: border, width: 2), borderRadius: BorderRadius.circular(16)),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: onTap,
              child: Center(child: Text(text, textAlign: TextAlign.center, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: size))),
            ),
          ),
        ),
      );
}

/// White rounded switcher (role selector, class list filter, report courses).
class Seg extends StatelessWidget {
  const Seg(this.items, this.index, this.onChanged, {super.key, this.size = 14});
  final List<String> items;
  final int index;
  final ValueChanged<int> onChanged;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: kShadow),
        child: Row(children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 42,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: i == index ? kPrimary : Colors.transparent, borderRadius: BorderRadius.circular(14)),
                  child: Text(items[i], maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: size, fontWeight: i == index ? FontWeight.w700 : FontWeight.w600, color: i == index ? Colors.white : kMuted)),
                ),
              ),
            ),
        ]),
      );
}

class Chips extends StatelessWidget {
  const Chips(this.items, this.index, this.onChanged, {super.key});
  final List<String> items;
  final int index;
  final ValueChanged<int> onChanged;
  @override
  Widget build(BuildContext context) => Wrap(spacing: 8, runSpacing: 8, children: [
        for (var i = 0; i < items.length; i++)
          GestureDetector(
            onTap: () => onChanged(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(color: i == index ? kPrimary : Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Text(items[i], style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: i == index ? Colors.white : kMuted)),
            ),
          ),
      ]);
}

class Avatar extends StatelessWidget {
  const Avatar(this.name, {super.key, this.size = 42});
  final String name;
  final double size;
  static const _cols = [kPrimary, Color(0xFF7C3AED), Color(0xFF2563EB), Color(0xFF0F766E), Color(0xFFB45309), Color(0xFFC2185B)];
  @override
  Widget build(BuildContext context) {
    final p = name.trim().split(' ');
    final ini = (p.first[0] + (p.length > 1 ? p[1][0] : '')).toUpperCase();
    final c = _cols[name.codeUnits.fold<int>(0, (a, b) => a + b) % _cols.length];
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
      child: Text(ini, style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: size * 0.33)),
    );
  }
}

class AppField extends StatelessWidget {
  const AppField(this.label, this.controller, {super.key, this.obscure = false, this.keyboard, this.hint, this.suffix, this.onSubmit, this.spacing, this.maxLength, this.errorText});
  final String label;
  final TextEditingController controller;
  final bool obscure;
  final TextInputType? keyboard;
  final String? hint, errorText;
  final Widget? suffix;
  final ValueChanged<String>? onSubmit;
  final double? spacing;
  final int? maxLength;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(padding: const EdgeInsets.only(left: 4, bottom: 5), child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800))),
        TextField(
          controller: controller,
          obscureText: obscure,
          keyboardType: keyboard,
          maxLength: maxLength,
          onSubmitted: onSubmit,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: spacing),
          decoration: InputDecoration(counterText: '', hintText: hint, errorText: errorText, suffixIcon: suffix),
        ),
      ]);
}

Future<void> copyToClipboard(BuildContext c, String text, String message) async {
  await Clipboard.setData(ClipboardData(text: text));
  if (c.mounted) toast(c, message);
}

class TabSpec {
  const TabSpec(this.label, this.root);
  final String label;
  final Widget root;
}

/// Bottom tabs. Every tab has its own Navigator, so the tab bar stays visible
/// on all inner screens (as in the design).
class AppShell extends StatefulWidget {
  const AppShell(this.tabs, {super.key});
  final List<TabSpec> tabs;
  @override
  State<AppShell> createState() => _ShellState();
}

class _ShellState extends State<AppShell> {
  int i = 0;
  late final keys = [for (final _ in widget.tabs) GlobalKey<NavigatorState>()];

  void _tap(int k) {
    if (k == i) {
      keys[k].currentState?.popUntil((r) => r.isFirst);
    } else {
      setState(() => i = k);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (didPop) return;
          final nav = keys[i].currentState;
          if (nav != null && nav.canPop()) {
            nav.pop();
          } else if (i != 0) {
            setState(() => i = 0);
          } else {
            SystemNavigator.pop();
          }
        },
        child: Scaffold(
          backgroundColor: kBg,
          body: IndexedStack(index: i, children: [
            for (var k = 0; k < widget.tabs.length; k++)
              Navigator(key: keys[k], onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => widget.tabs[k].root)),
          ]),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 20),
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24)), boxShadow: [BoxShadow(color: Color(0x141E1B4B), blurRadius: 20, offset: Offset(0, -6))]),
            child: SafeArea(
              top: false,
              child: Row(children: [
                for (var k = 0; k < widget.tabs.length; k++)
                  Expanded(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => _tap(k),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        height: 46,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: k == i ? kPrimary : Colors.transparent, borderRadius: BorderRadius.circular(14)),
                        child: Text(widget.tabs[k].label, style: TextStyle(fontSize: widget.tabs.length > 3 ? 13 : 14, fontWeight: k == i ? FontWeight.w800 : FontWeight.w700, color: k == i ? Colors.white : kMuted)),
                      ),
                    ),
                  ),
              ]),
            ),
          ),
        ),
      );
}
