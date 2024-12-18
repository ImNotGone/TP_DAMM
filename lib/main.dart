import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/firebase_providers.dart';
import 'package:ser_manos_mobile/providers/router_provider.dart';
import 'package:ser_manos_mobile/providers/app_state_provider.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './translations/codegen_loader.g.dart';
import 'auth/domain/app_user.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp();

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  final prefs = await SharedPreferences.getInstance();
  final hasSeenWelcomeScreen = prefs.getBool('hasSeenWelcomeScreen') ?? false;

  final container = ProviderContainer();
  await _initializeProviders(container, hasSeenWelcomeScreen);
  _setNotificationListener(container);

  runApp(
      UncontrolledProviderScope(
        container: container,
        child: EasyLocalization(
            supportedLocales: [
              Locale('en'),
              Locale('es'),
            ],
            assetLoader: CodegenLoader(),
            fallbackLocale: Locale('en'),
            path: 'assets/translations',
            child: const MyApp(),
        )
      )
  );
}

void _setNotificationListener(ProviderContainer container){
  container.read(firebaseMessagingProvider).getInitialMessage()
      .then((RemoteMessage? message) {
    if (message == null) return;
    if (message.data.containsKey('deepLink')) {
      final deepLink = message.data['deepLink'];
      container.read(routerProvider).go(deepLink);
    }
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.data.containsKey('deepLink')) {
      final deepLink = message.data['deepLink'];
      container.read(routerProvider).go(deepLink);
    }
  });
}

Future<void> _initializeProviders(
    ProviderContainer container, bool hasSeenWelcomeScreen) async {
  container.read(hasSeenWelcomeScreenProvider.notifier).state =
      hasSeenWelcomeScreen;

  AppUser? currentUser;
  try {
    final userService = container.read(userServiceProvider);
    currentUser = await userService.getCurrentUser();
    if (currentUser != null) {
      container.read(appStateNotifierProvider.notifier).authenticate();

      String? oldToken = currentUser.fcmToken;
      String? newtoken =
          await container.read(firebaseMessagingProvider).getToken();

      if (oldToken != newtoken) {
        currentUser.fcmToken = newtoken;
        await userService.updateUser(currentUser);
      }

      container.read(currentUserNotifierProvider.notifier).setUser(currentUser);
    }
  } catch (e) {
    container.read(appStateNotifierProvider.notifier).unauthenticate();
  } finally {
    container
        .read(firebaseMessagingProvider)
        .requestPermission(provisional: true);
    container.read(firebaseMessagingProvider).setAutoInitEnabled(true);
    container
        .read(firebaseAnalyticsProvider)
        .setAnalyticsCollectionEnabled(true);
  }
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    useEffect(() {
      FlutterNativeSplash.remove();
      return null;
    }, []);

    const MaterialColor primarySwatch = MaterialColor(
      0xff14903F,
      <int, Color>{
        5: Color(0xFFf3f9f5),
        10: Color(0xFFe7f4ec),
        100: Color(0xFF14903f),
      },
    );

    const MaterialColor secondarySwatch = MaterialColor(
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

    const MaterialColor neutralSwatch = MaterialColor(
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

    return MaterialApp.router(
      title: 'Ser Manos',
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      locale: context.locale,
      routerConfig: router,
      theme: ThemeData(
        fontFamily: 'Roboto',
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
