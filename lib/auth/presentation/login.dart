import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/auth/application/user_service.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import '../../shared/molecules/buttons/text.dart';
import '../domain/app_user.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final isButtonEnabled = useState(false);

    final UserService userService = ref.watch(userServiceProvider);

    // Enable or disable the login button when text changes
    void updateButtonState() {
      isButtonEnabled.value = emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    }

    // Attach listeners to the text controllers
    useEffect(() {
      emailController.addListener(updateButtonState);
      passwordController.addListener(updateButtonState);

      // Clean up listeners when widget is disposed
      return () {
        emailController.removeListener(updateButtonState);
        passwordController.removeListener(updateButtonState);
      };
    }, []);

    Future<void> handleLogin() async {
      await userService.signIn(
        emailController.text,
        passwordController.text,
      );

      if (userService.isLoggedIn()) {
        AppUser? appUser = await userService.getCurrentUser();
        ref.read(currentUserNotifierProvider.notifier).setUser(appUser);

        if(context.mounted) {
          context.go('/post_login_welcome');
        }
      } else {
        log('Login failed');
        // Handle login failure (e.g., show a snackbar or dialog)
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/logo_square.png', width: 150, height: 150), // Logo at the top
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildTextField(
                      controller: emailController,
                      hintText: AppLocalizations.of(context)!.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildPasswordField(
                      passwordController: passwordController,
                      obscurePassword: obscurePassword,
                      hintText: AppLocalizations.of(context)!.password,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  UtilFilledButton(
                    onPressed: isButtonEnabled.value ? handleLogin : null,
                    text: AppLocalizations.of(context)!.login,
                  ),
                  const SizedBox(height: 8),
                  UtilTextButton(
                    onPressed: () {
                      context.go('/sign_up');
                    },
                    text: AppLocalizations.of(context)!.noAccount,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildPasswordField({
    required TextEditingController passwordController,
    required ValueNotifier<bool> obscurePassword,
    required String hintText,
  }) {
    return ValueListenableBuilder<bool>(
      valueListenable: obscurePassword,
      builder: (context, obscure, _) {
        return TextField(
          controller: passwordController,
          obscureText: obscure,
          decoration: InputDecoration(
            hintText: hintText,
            border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: Icon(
                obscure ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () => obscurePassword.value = !obscurePassword.value,
            ),
          ),
        );
      },
    );
  }
}
