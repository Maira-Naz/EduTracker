// Student account: profile, change password, notifications, sign out.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../auth/sign_out.dart';
import 'change_password_screen.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});
  @override
  State<AccountTab> createState() => _AccountState();
}

class _AccountState extends State<AccountTab> {
  Widget _row(String label, {Widget? trailing, VoidCallback? onTap}) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
            if (trailing != null) trailing,
          ]),
        ),
      );

  Widget _toggle(bool on, ValueChanged<bool> f) => GestureDetector(
        onTap: () => f(!on),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 48,
          height: 28,
          padding: const EdgeInsets.symmetric(horizontal: 3),
          alignment: on ? Alignment.centerRight : Alignment.centerLeft,
          decoration: BoxDecoration(color: on ? kPrimary : kBorder, borderRadius: BorderRadius.circular(99)),
          child: Container(width: 22, height: 22, decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle)),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final s = Store.i;
    return Screen(
      title: 'Account',
      gap: 16,
      children: [
        Panel(
          radius: 24,
          child: Row(children: [
            Avatar(s.name, size: 60),
            const SizedBox(width: 14),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(s.name, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w800)),
                Padding(padding: const EdgeInsets.only(top: 2), child: Text('${s.uid} · BS Computer Science', style: kRowSub)),
              ]),
            ),
          ]),
        ),
        Panel(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
          child: Column(children: [
            _row('Change password', trailing: const Text('›', style: TextStyle(fontSize: 18, color: kMuted)), onTap: () => go(context, const ChangePasswordScreen())),
            const Divider(height: 1, thickness: 1, color: kDivider),
            _row('Registered phone', trailing: const Text('+92 3•• ••• 4821', style: TextStyle(fontSize: 14, color: kMuted))),
            const Divider(height: 1, thickness: 1, color: kDivider),
            _row('Notify me when below 75%', trailing: _toggle(s.notifyLow, (v) => setState(() => s.notifyLow = v))),
          ]),
        ),
        OButton('Sign out', () => confirmSignOut(context), height: 52, border: const Color(0xFFF3C9C4), color: kRed),
      ],
    );
  }
}
