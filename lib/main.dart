import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos_mobile/auth/presentation/login.dart';
import 'package:ser_manos_mobile/auth/presentation/postlogin_welcome.dart';
import 'package:ser_manos_mobile/auth/presentation/prelogin_welcome.dart';
import 'package:ser_manos_mobile/auth/presentation/signup.dart';

import 'home/presentation/home_page.dart';
import 'home/presentation/news_detail.dart';
import 'home/presentation/volunteering_detail.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final GoRouter _router = GoRouter(initialLocation: '/', routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const PreLoginWelcome(),
    ),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
        path: '/sign_up', builder: (context, state) => const SignUpScreen()),
    GoRoute(
        path: '/post_login_welcome',
        builder: (context, state) => const PostLoginWelcome()),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/newsDetail/:id',
      builder: (context, state) {
        final newsId = state.extra as String; // Cast 'extra' to your news type
        return NewsDetail(newsId: newsId);
      },
    ),
    GoRoute(
      path: '/volunteering/:id',
      builder: (context, state) {
        final volunteeringId = state.extra as String;
        return VolunteeringDetail(volunteeringId: volunteeringId);
      },
    ),
  ]);

  final MaterialColor primarySwatch = const MaterialColor(
    0xff14903F,
    <int, Color>{
      5: Color(0xFFf3f9f5),
      10: Color(0xFFe7f4ec),
      100: Color(0xFF14903f),
    },
  );

  final MaterialColor secondarySwatch = const MaterialColor(
    0xff2C98F0,
    <int, Color>{
      10: Color(0xFFE1ECF5),
      25: Color(0xFFCAE5FB),
      50: Color(0xFF90CAF9),
      80: Color(0xFF6CB6F3),
      90: Color(0xff4AA9F5),
      100: Color(0xff2C98F0),
      200: Color(0xff0D47A1),
    },
  );

  final MaterialColor neutralSwatch = const MaterialColor(
    0xff191919,
    <int, Color>{
      0: Color(0xFFFFFFFF),
      10: Color(0xFFFAFAFA),
      25: Color(0xFFE0E0E0),
      50: Color(0xFF9E9E9E),
      75: Color(0xff666666),
      100: Color(0xff191919),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ser Manos',
      routerConfig: _router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        fontFamily: 'Roboto',
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.18,
            height: 1.0
          ),
          headlineMedium: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: 0.15,
            height: 1.2
          ),
          titleMedium: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.15,
            height: 1.5
          ),
          bodyLarge: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.25,
            height: 1.43
          ),
          bodyMedium: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            letterSpacing: 0.4,
            height: 1.34
          ),
          bodySmall: TextStyle(
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            color: Color(0xff191919),
            letterSpacing: 0.4,
            height: 1.34
          ),
          labelLarge: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            letterSpacing: 0.1,
            height: 1.43
          ),
          labelSmall: TextStyle(
            fontSize: 10.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 1.5,
            color: Colors.black,
            height: 1.6
          ),
        ),
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: primarySwatch[100]!,
          onPrimary: neutralSwatch[0]!,
          primaryContainer: neutralSwatch[0]!,
          onPrimaryContainer: neutralSwatch[100]!,
          secondary: secondarySwatch[100]!,
          onSecondary: neutralSwatch[0]!,
          secondaryContainer: secondarySwatch[200]!,
          secondaryFixed: secondarySwatch[25]!,
          error: const Color(0xFFB3261E),
          onError: neutralSwatch[0]!,
          surface: secondarySwatch[10]!,
          onSurface: neutralSwatch[100]!,
          outline: neutralSwatch[25]!,
        ),
        iconTheme: IconThemeData(
          color: neutralSwatch[75],
        ),
        useMaterial3: true,
      ),
    );
  }
}
