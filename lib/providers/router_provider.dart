import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../auth/domain/app_start_state.dart';
import '../auth/presentation/login.dart';
import '../auth/presentation/postlogin_welcome.dart';
import '../auth/presentation/prelogin_welcome.dart';
import '../auth/presentation/signup.dart';
import '../home/presentation/home_page.dart';
import '../news/presentation/news_detail.dart';
import '../profile/presentation/profile_edit_screen.dart';
import '../volunteer/presentation/volunteer_detail.dart';
import 'app_state_provider.dart';

final hasSeenWelcomeScreenProvider = StateProvider<bool>((ref) => false);

final routerProvider = Provider<GoRouter>((ref) {
  final appStartState = ref.watch(appStateNotifierProvider);
  final isAuthenticated = ref.watch(appStateNotifierProvider) == AppStartState.authenticated;

  return GoRouter(
    initialLocation: isAuthenticated ? '/home' : '/',
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
});