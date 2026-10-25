// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:edu_tracker/main.dart';

void main() {
  testWidgets('Student can sign in and see courses', (WidgetTester tester) async {
    await tester.pumpWidget(const PresenceApp());

    // Login screen is shown.
    expect(find.text('Welcome to EduTracker'), findsOneWidget);

    // Sign in with the demo student account.
    await tester.enterText(find.byType(TextField).at(0), 'CS-2041');
    await tester.enterText(find.byType(TextField).at(1), '12345678');
    await tester.ensureVisible(find.text('Sign in'));
    await tester.tap(find.text('Sign in'));
    await tester.pumpAndSettle();

    // Student home (Courses tab) is shown.
    expect(find.text('My courses'), findsWidgets);
  });
}
