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
import 'package:ser_manos_mobile/shared/molecules/inputs/password_input.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/text_input.dart';
import '../../shared/molecules/buttons/text.dart';
import '../../shared/molecules/inputs/validation/email_validation.dart';
import '../../shared/molecules/inputs/validation/password_validation.dart';
import '../../shared/molecules/inputs/validation/required_validation.dart';
import '../../shared/molecules/inputs/validation/validator.dart';
import '../../shared/tokens/colors.dart';
import '../domain/app_user.dart';
final formKey = GlobalKey<FormState>();

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final isLoginEnabled = useState(false);

    final UserService userService = ref.watch(userServiceProvider);

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
      backgroundColor: SerManosColors.neutral0,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    onChanged: () {
                      isLoginEnabled.value = formKey.currentState?.validate() ?? false;
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset('assets/logo_square.png', width: 150, height: 150), // Logo at the top
                        const SizedBox(height: 16),
                        TextInput(
                          label: AppLocalizations.of(context)!.email,
                          labelWhenEmpty: false,
                          hintText: AppLocalizations.of(context)!.email,
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: Validator.apply(
                              context,
                              [
                                const RequiredValidation(),
                                const EmailValidation()
                              ]
                          ),
                        ),
                        const SizedBox(height: 16),
                        PasswordInput(
                          label: AppLocalizations.of(context)!.password,
                          labelWhenEmpty: false,
                          hintText: AppLocalizations.of(context)!.password,
                          controller: passwordController,
                          validator: Validator.apply(
                              context,
                              [
                                const RequiredValidation(),
                                const PasswordValidation()
                              ]
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                UtilFilledButton(
                  onPressed: isLoginEnabled.value ? handleLogin : null,
                  text: AppLocalizations.of(context)!.login,
                ),
                const SizedBox(height: 8),
                UtilTextButton(
                  onPressed: () {
                    context.replace('/sign_up');
                  },
                  text: AppLocalizations.of(context)!.noAccount,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
