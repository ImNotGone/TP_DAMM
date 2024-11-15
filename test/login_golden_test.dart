import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos_mobile/auth/presentation/login.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/password_input.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/text_input.dart';

import 'mocks/user_service.mocks.dart';


void main() {
  setUpAll(() async {
    // Initialize Firebase before running tests
    await Firebase.initializeApp();
  });
  // Initialize golden tests
  group('LoginScreen Golden Tests', () {

    // Test 1: Initial Login Screen
    testGoldens('Initial LoginScreen', (tester) async {
      await tester.pumpWidgetBuilder(
        const ProviderScope(
          child: LoginScreen(),
        ),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
      );
      await screenMatchesGolden(tester, 'login_screen_initial');
    });

    // Test 2: Login Screen with Invalid Email Input
    testGoldens('LoginScreen with invalid email', (tester) async {
      await tester.pumpWidgetBuilder(
        const ProviderScope(
          child: LoginScreen(),
        ),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
      );

      await tester.enterText(find.byType(TextInput).at(0), 'invalid_email');
      await tester.pump();

      await screenMatchesGolden(tester, 'login_screen_invalid_email');
    });

    // Test 3: Login Screen with Valid Email and Password (Button enabled)
    testGoldens('LoginScreen with valid email and password', (tester) async {
      await tester.pumpWidgetBuilder(
        const ProviderScope(
          child: LoginScreen(),
        ),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
      );

      await tester.enterText(find.byType(TextInput).at(0), 'user@example.com');
      await tester.enterText(find.byType(PasswordInput).at(0), 'Password123!');
      await tester.pump();

      await screenMatchesGolden(tester, 'login_screen_valid_inputs');
    });

    // Test 4: Login Screen with login failure state
    testGoldens('LoginScreen login failure', (tester) async {
      final mockUserService = MockUserService();
      when(mockUserService.isLoggedIn()).thenReturn(false);

      await tester.pumpWidgetBuilder(
        ProviderScope(
          overrides: [
            userServiceProvider.overrideWithValue(mockUserService),
          ],
          child: const LoginScreen(),
        ),
        wrapper: materialAppWrapper(theme: ThemeData.light()),
      );

      // Enter valid credentials
      await tester.enterText(find.byType(TextInput).at(0), 'user@example.com');
      await tester.enterText(find.byType(PasswordInput).at(0), 'Password123!');
      await tester.tap(find.text('Login'));  // Tap the login button
      await tester.pump();

      await screenMatchesGolden(tester, 'login_screen_login_failure');
    });
  });
}
