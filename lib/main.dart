import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/student_store.dart';
import 'data/teacher_store.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  ));
  runApp(const EduTrackApp());
}

class EduTrackApp extends StatelessWidget {
  const EduTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TeacherStore()),
        ChangeNotifierProvider(create: (_) => StudentStore()),
        // AdminStore is added here in the next module.
      ],
      child: MaterialApp(
        title: 'EduTrack',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(),
        initialRoute: Routes.login,
        onGenerateRoute: AppRouter.onGenerate,
      ),
    );
  }
}
