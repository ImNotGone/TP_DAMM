import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/auth/presentation/login.dart';
import 'package:ser_manos_mobile/auth/presentation/postlogin_welcome.dart';
import 'package:ser_manos_mobile/providers/auth_service_provider.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import '../../shared/molecules/buttons/text.dart';
import '../application/auth_service.dart';

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);

    final AuthService authServiceInstance = ref.watch(authServiceProvider);

    Future<void> handleSignup() async {
      final user = await authServiceInstance.signUpWithEmailAndPassword(
        emailController.text,
        passwordController.text,
      );

      if (user != null && context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PostLoginWelcome()),
        );
      } else {
        log('Sign-up failed');
        // Handle sign-up failure (e.g., show a snackbar or dialog)
      }
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/logo_square.png'),
                const SizedBox(height: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.name),
                        hintText: AppLocalizations.of(context)!.nameExample,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: lastNameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.lastName),
                        hintText: AppLocalizations.of(context)!.lastNameExample,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.email),
                        hintText: AppLocalizations.of(context)!.emailExample,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.password),
                        hintText: AppLocalizations.of(context)!.passwordExample,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            obscurePassword.value
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            obscurePassword.value = !obscurePassword.value;
                          },
                        ),
                      ),
                      obscureText: obscurePassword.value,
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                UtilFilledButton(
                    onPressed: (nameController.text.isNotEmpty &&
                        lastNameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty)
                        ? handleSignup
                        : null,
                    text: AppLocalizations.of(context)!.signUp),
                const SizedBox(height: 8),
                UtilTextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginScreen(),
                      ),
                    );
                  },
                  text: AppLocalizations.of(context)!.haveAccount,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
