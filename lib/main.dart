import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos_mobile/auth/presentation/prelogin_welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
      const ProviderScope(
          child: MyApp()
      )
  );
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Ser Manos',
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black,
            ),
            // Roboto Regular 24px
            headlineMedium: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500, // Medium weight
              color: Colors.black,
            ),
            // Roboto Medium 20px
            titleMedium: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black,
            ),
            // Roboto Regular 16px
            bodyLarge: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black,
            ),
            // Roboto Regular 14px
            bodyMedium: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black,
            ),
            // Roboto Regular 12px
            bodySmall: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black54,
            ),
            labelLarge: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500, // Medium weight
              color: Colors.black,
            ),
            // Roboto Medium 14px
            // Roboto Regular 12px (for caption)
            labelSmall: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              // Medium weight
              letterSpacing: 1.5,
              // Usually overlines have larger letter-spacing
              color: Colors.black,
            ), // Roboto Medium 10px
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
            primary: Colors.blue,
            onPrimary: Colors.white,
            primaryContainer: Colors.blue.shade900,
            secondary: Colors.green,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          useMaterial3: true,
        ),
        home: const PreLoginWelcome());
  }
}