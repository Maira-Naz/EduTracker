import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:edu_tracker/main.dart';

void main() {
  testWidgets('Teacher can sign in and see rooms', (WidgetTester tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    await tester.pumpWidget(const EduTrackerApp());

    expect(find.textContaining('EduTracker'), findsWidgets);

    await tester.ensureVisible(find.text('Sign in securely'));
    await tester.tap(find.text('Sign in securely'));
    await tester.pumpAndSettle();

    expect(find.text('Your rooms'), findsOneWidget);
  });
}
