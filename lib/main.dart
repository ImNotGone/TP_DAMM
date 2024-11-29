import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/auth/domain/app_start_state.dart';
import 'package:ser_manos_mobile/auth/presentation/login.dart';
import 'package:ser_manos_mobile/auth/presentation/postlogin_welcome.dart';
import 'package:ser_manos_mobile/auth/presentation/prelogin_welcome.dart';
import 'package:ser_manos_mobile/auth/presentation/signup.dart';
import 'package:ser_manos_mobile/auth/presentation/loading_screen.dart';
import 'package:ser_manos_mobile/profile/presentation/profile_edit_screen.dart';
import 'package:ser_manos_mobile/home/presentation/home_page.dart';
import 'package:ser_manos_mobile/news/presentation/news_detail.dart';
import 'package:ser_manos_mobile/volunteer/presentation/volunteer_detail.dart';
import 'package:ser_manos_mobile/providers/app_state_provider.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';

import 'auth/domain/app_user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends HookConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userService = ref.read(userServiceProvider);
    final AppStartState appStartState = ref.watch(appStateNotifierProvider);

    useEffect(() {
      Future<void> fetchUser() async {
        if (userService.isLoggedIn()) {
          AppUser? user = await userService.getCurrentUser();
          Future(() {
            if (user != null) {
              ref.read(currentUserNotifierProvider.notifier).setUser(user);
              ref.read(appStateNotifierProvider.notifier).authenticate();
            } else {
              ref.read(appStateNotifierProvider.notifier).unauthenticate();
            }
          });
        } else {
          Future(() {
            ref.read(appStateNotifierProvider.notifier).unauthenticate();
          });
        }
      }

      fetchUser();
      return null;
    }, []);

    final GoRouter router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const PreLoginWelcome(),
        ),
        GoRoute(
            path: '/login', builder: (context, state) => const LoginScreen()
        ),
        GoRoute(
            path: '/sign_up',
            builder: (context, state) => const SignUpScreen()
        ),
        GoRoute(
            path: '/post_login_welcome',
            builder: (context, state) => const PostLoginWelcome()
        ),
        GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage()
        ),
        GoRoute(
          path: '/newsDetail/:id',
          builder: (context, state) {
            final newsId = state.pathParameters['id'];
            return NewsDetail(newsId: newsId!);
          },
        ),
        GoRoute(
          path: '/volunteering/:id',
          builder: (context, state) {
            final volunteeringId = state.pathParameters['id'];
            return VolunteeringDetail(volunteeringId: volunteeringId!);
          },
        ),
        GoRoute(
          path: '/profile_edit',
          builder: (context, state) {
            if(state.extra == null) {
              return const ProfileEditScreen();
            }
            final String volunteeringId = state.extra as String;
            return ProfileEditScreen(volunteeringId: volunteeringId);
          },
        )
      ],
        redirect: (context, state) {
         final allowedPaths = ['/', '/login', '/sign_up', '/post_login_welcome'];

          if (appStartState == AppStartState.unauthenticated && !allowedPaths.contains(state.matchedLocation)) {
            return '/login';
          }

          if (appStartState == AppStartState.authenticated && state.matchedLocation == '/') {
            return '/home';
          }

          return null;
        },
    );

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
      routerConfig: router,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
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
      builder: (context, child) {
        if (appStartState == AppStartState.loading) {
          return const LoadingScreen();
        }
        return child!;
      },
    );
  }
}
