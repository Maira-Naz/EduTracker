// Reusable UI building blocks used by every screen: cards, pills, tiles,
// segmented control, page scaffold (Screen) and the bottom-tab shell (AppShell).
import 'package:flutter/material.dart';
import 'theme.dart';

/// Opens [screen] on top of the current one.
void go(BuildContext c, Widget screen) => Navigator.push(c, MaterialPageRoute(builder: (_) => screen));

class Pill extends StatelessWidget {
  const Pill(this.text, this.tone, {super.key});
  final String text;
  final Tone tone;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(color: toneBg(tone), borderRadius: BorderRadius.circular(99)),
        child: Text(text, style: TextStyle(color: toneFg(tone), fontSize: 12, fontWeight: FontWeight.w600)),
      );
}

class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.onTap, this.color = Colors.white, this.border = kLine, this.padding = const EdgeInsets.all(16)});
  final Widget child;
  final VoidCallback? onTap;
  final Color color, border;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Material(
          color: color,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: border)),
          child: InkWell(onTap: onTap, child: Padding(padding: padding, child: SizedBox(width: double.infinity, child: child))),
        ),
      );
}

class Item extends StatelessWidget {
  const Item(this.title, {super.key, this.sub, this.leading, this.trailing});
  final String title;
  final String? sub;
  final Widget? leading, trailing;

  @override
  Widget build(BuildContext context) => Row(children: [
        if (leading != null) ...[leading!, const SizedBox(width: 12)],
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: kH3),
            if (sub != null) Padding(padding: const EdgeInsets.only(top: 2), child: Text(sub!, style: kMut)),
          ]),
        ),
        if (trailing != null) ...[const SizedBox(width: 12), trailing!],
      ]);
}

class Hr extends StatelessWidget {
  const Hr({super.key});
  @override
  Widget build(BuildContext context) => const Divider(height: 28, color: Color(0xFFECEEF6));
}

class Section extends StatelessWidget {
  const Section(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.only(top: 24), child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: kInk)));
}

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.text, {super.key});
  final String text;
  @override
  Widget build(BuildContext context) =>
      Padding(padding: const EdgeInsets.only(top: 16, bottom: 6), child: Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)));
}

Widget emptyNote(String t) => AppCard(child: Text(t, style: kMut, textAlign: TextAlign.center));

class StatTile extends StatelessWidget {
  const StatTile(this.value, this.label, {super.key, this.bg = Colors.white, this.fg = kInk, this.onTap});
  final String value, label;
  final Color bg, fg;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: bg,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: bg == Colors.white ? kLine : bg)),
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              Text(value, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700, color: fg)),
              Text(label, style: TextStyle(fontSize: 13, color: fg)),
            ]),
          ),
        ),
      );
}

Widget tileRow(List<Widget> t) => Padding(
      padding: const EdgeInsets.only(top: 16),
      child: IntrinsicHeight(
        child: Row(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          for (var i = 0; i < t.length; i++) ...[if (i > 0) const SizedBox(width: 12), Expanded(child: t[i])],
        ]),
      ),
    );

class PercentBar extends StatelessWidget {
  const PercentBar(this.pct, {super.key});
  final num pct;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: LinearProgressIndicator(value: pct / 100, minHeight: 8, backgroundColor: kGrey, valueColor: AlwaysStoppedAnimation(barColor(pct))),
        ),
      );
}

class Seg extends StatelessWidget {
  const Seg(this.items, this.index, this.onChanged, {super.key});
  final List<String> items;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: kGrey, borderRadius: BorderRadius.circular(14)),
        child: Row(children: [
          for (var i = 0; i < items.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onChanged(i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: i == index ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(11)),
                  child: Text(items[i], style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: i == index ? kInk : kMuted)),
                ),
              ),
            ),
        ]),
      );
}

class Avatar extends StatelessWidget {
  const Avatar(this.name, {super.key});
  final String name;
  @override
  Widget build(BuildContext context) {
    const cols = [Color(0xFFC2185B), Color(0xFF0E7490), Color(0xFF7C3AED), Color(0xFF15803D)];
    final p = name.split(' ');
    final ini = (p.first[0] + (p.length > 1 ? p[1][0] : '')).toUpperCase();
    return CircleAvatar(radius: 22, backgroundColor: cols[name.length % cols.length], child: Text(ini, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14)));
  }
}

class Screen extends StatelessWidget {
  const Screen({super.key, required this.title, required this.children, this.subtitle, this.back = false, this.backLabel, this.trailing, this.onRefresh});
  final String title;
  final String? subtitle, backLabel;
  final bool back;
  final Widget? trailing;
  final List<Widget> children;
  final Future<void> Function()? onRefresh;

  @override
  Widget build(BuildContext context) {
    final list = ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      children: [
        if (back)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => Navigator.maybePop(context),
              style: TextButton.styleFrom(foregroundColor: kViolet, padding: EdgeInsets.zero),
              icon: const Icon(Icons.arrow_back, size: 18),
              label: Text(backLabel ?? 'Back'),
            ),
          ),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              if (subtitle != null) Text(subtitle!, style: kMut),
              Text(title, style: kH1),
            ]),
          ),
          if (trailing != null) trailing!,
        ]),
        ...children,
      ],
    );
    return Scaffold(body: SafeArea(child: onRefresh == null ? list : RefreshIndicator(onRefresh: onRefresh!, child: list)));
  }
}

class NavItem {
  const NavItem(this.icon, this.active, this.label);
  final IconData icon, active;
  final String label;
}

class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.tabs, required this.items});
  final List<Widget> tabs;
  final List<NavItem> items;
  @override
  State<AppShell> createState() => _ShellState();
}

class _ShellState extends State<AppShell> {
  int i = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
        body: IndexedStack(index: i, children: widget.tabs),
        bottomNavigationBar: NavigationBar(
          selectedIndex: i,
          onDestinationSelected: (v) => setState(() => i = v),
          destinations: [
            for (final d in widget.items) NavigationDestination(icon: Icon(d.icon), selectedIcon: Icon(d.active, color: kViolet), label: d.label),
          ],
        ),
      );
}
