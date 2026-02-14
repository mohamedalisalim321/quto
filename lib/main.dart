import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'databases/quotes_database.dart';
import 'pages/home_page.dart';
import 'themes/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    debugPrint('❌ Flutter Error: ${details.exception}');
  };

  try {
    await QuotesDatabase.init();

    debugPrint('✅ App initialized successfully');
  } catch (e, stack) {
    debugPrint('❌ App initialization failed');
    debugPrint('$e');
    debugPrint('$stack');
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const QutoApp(),
    ),
  );
}

class QutoApp extends StatelessWidget {
  const QutoApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>();

    return ScreenUtilInit(
      designSize: const Size(392, 800),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: theme.themeData,
        themeMode: ThemeMode.system,
        themeAnimationDuration: const Duration(milliseconds: 350),
        themeAnimationCurve: Curves.easeInOut,
        home: const HomePage(),
      ),
    );
  }
}
