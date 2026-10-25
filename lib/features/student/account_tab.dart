// Student account, notifications switch, sign out.
import 'package:flutter/material.dart';
import '../../core/core.dart';
import 'change_password_screen.dart';
import '../auth/profile_menu.dart';

class AccountTab extends StatefulWidget {
  const AccountTab({super.key});
  @override
  State<AccountTab> createState() => _AccountState();
}

class _AccountState extends State<AccountTab> {
  bool notify = true;
  @override
  Widget build(BuildContext context) => Screen(
        title: 'Account',
        subtitle: 'Signed in',
        children: [
          AppCard(
            child: Item(Store.i.uid,
                sub: 'Computer Science · Current semester',
                leading: const CircleAvatar(radius: 24, backgroundColor: Color(0xFF0E7490), child: Text('CS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)))),
          ),
          AppCard(
            child: Column(children: [
              InkWell(
                onTap: () => go(context, const ChangePasswordScreen()),
                child: const Padding(padding: EdgeInsets.symmetric(vertical: 4), child: Item('Change password', trailing: Icon(Icons.chevron_right, color: kMuted))),
              ),
              const Hr(),
              const Item('Registered phone', trailing: Text('•••• 4821', style: kMut)),
              const Hr(),
              Item('Notifications', trailing: Switch(value: notify, onChanged: (v) => setState(() => notify = v))),
            ]),
          ),
          const SizedBox(height: 16),
          OutlinedButton(onPressed: () => confirmSignOut(context), child: const Text('Sign out')),
        ],
      );
}
