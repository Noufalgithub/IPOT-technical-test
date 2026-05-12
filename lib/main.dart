import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:ipot_technical_test/l10n/app_localizations.dart';
import 'core/theme/app_theme.dart';
import 'injection_container.dart';
import 'router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Setup dependency injection
  setupDependencies();
  
  // Set system UI overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppTheme.surfaceDark,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(const IPOTOrderingApp());
}

class IPOTOrderingApp extends StatelessWidget {
  const IPOTOrderingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'IPOT Digital Ordering',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: AppRouter.router,
    );
  }
}
