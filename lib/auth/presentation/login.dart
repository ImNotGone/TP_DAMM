import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/auth/application/auth_service.dart';
import 'package:ser_manos_mobile/auth/presentation/postlogin_welcome.dart';
import 'package:ser_manos_mobile/auth/presentation/signup.dart';
import 'package:ser_manos_mobile/main.dart';
import 'package:ser_manos_mobile/providers/auth_service_provider.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import '../../shared/molecules/buttons/text.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final isButtonEnabled = useState(false);

    final AuthService authServiceInstance = ref.watch(authServiceProvider);

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
      final user = await authServiceInstance.signInWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (user != null && context.mounted) {
        context.go('/post_login_welcome');
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
                  Image.asset('assets/logo_square.png'), // Logo at the top
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
