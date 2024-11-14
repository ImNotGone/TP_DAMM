import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/auth/application/user_service.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/text_input.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/email_validation.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/password_validation.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/required_validation.dart';
import '../../providers/user_provider.dart';
import '../../shared/molecules/buttons/text.dart';
import '../../shared/molecules/inputs/password_input.dart';
import '../../shared/molecules/inputs/validation/validator.dart';
import '../domain/app_user.dart';

final formKey = GlobalKey<FormState>();

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final nameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isSignUpButtonEnabled = useState(false);

    final UserService userService = ref.watch(userServiceProvider);

    Future<void> handleSignup() async {
      await userService.signUp(
        nameController.text,
        lastNameController.text,
        emailController.text,
        passwordController.text,
      );

      if (userService.isLoggedIn() && context.mounted) {
        AppUser? appUser = await userService.getCurrentUser();
        ref.read(currentUserNotifierProvider.notifier).setUser(appUser);

        if(context.mounted){
          context.go('/post_login_welcome');
        }
      } else {
        log('Sign-up failed');
        // Handle sign-up failure (e.g., show a snackbar or dialog)
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Image.asset(
                          'assets/logo_square.png',
                          height: 150,
                          width: 150,
                        ),
                        const SizedBox(height: 32),
                        Form(
                          key: formKey,
                          onChanged: () {
                            isSignUpButtonEnabled.value = formKey.currentState?.validate() ?? false;
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextInput(
                                  label: AppLocalizations.of(context)!.name,
                                  hintText: AppLocalizations.of(context)!.nameHint,
                                  controller: nameController,
                                  keyboardType: TextInputType.text,
                                  validator: Validator.apply(
                                      context,
                                      [
                                        const RequiredValidation(),
                                      ]
                                  )
                              ),
                              const SizedBox(height: 16),
                              TextInput(
                                  label: AppLocalizations.of(context)!.lastName,
                                  hintText: AppLocalizations.of(context)!.lastNameHint,
                                  controller: lastNameController,
                                  keyboardType: TextInputType.text,
                                  validator: Validator.apply(
                                      context,
                                      [
                                        const RequiredValidation(),
                                      ]
                                  )
                              ),
                              const SizedBox(height: 16),
                              TextInput(
                                label: AppLocalizations.of(context)!.email,
                                hintText: AppLocalizations.of(context)!.emailHint,
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
                                hintText: AppLocalizations.of(context)!.passwordHint,
                                controller: passwordController,
                                validator: Validator.apply(
                                  context,
                                  [
                                    const RequiredValidation(),
                                    const PasswordValidation()
                                  ]
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    UtilFilledButton(
                        onPressed: isSignUpButtonEnabled.value
                            ? handleSignup
                            : null,
                        text: AppLocalizations.of(context)!.signUp),
                    const SizedBox(height: 8),
                    UtilTextButton(
                      onPressed: () {
                        context.go('/login');
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