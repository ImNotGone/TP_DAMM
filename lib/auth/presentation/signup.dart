import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/auth/application/user_service.dart';
import 'package:ser_manos_mobile/providers/firebase_providers.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/text_input.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/email_validation.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/password_validation.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/required_validation.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/router_provider.dart';
import '../../providers/user_provider.dart';
import '../../shared/molecules/buttons/text.dart';
import '../../shared/molecules/inputs/password_input.dart';
import '../../shared/molecules/inputs/validation/validator.dart';
import '../../shared/tokens/colors.dart';
import '../../shared/tokens/text_style.dart';
import '../../translations/locale_keys.g.dart';
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
    final isLoading = useState(false);

    final UserService userService = ref.watch(userServiceProvider);

    Future<void> handleSignup() async {
      isLoading.value = true;
      try {
        String? fcmToken = await ref.read(firebaseMessagingProvider).getToken();
        await userService.signUp(
          nameController.text,
          lastNameController.text,
          emailController.text,
          passwordController.text,
          fcmToken!,
        );

        if (userService.isLoggedIn() && context.mounted) {
          AppUser? appUser = await userService.getCurrentUser();
          ref.read(currentUserNotifierProvider.notifier).setUser(appUser);

          if (context.mounted) {
            if (!ref.read(hasSeenWelcomeScreenProvider)) {
              context.go('/post_login_welcome');
            } else {
              ref.read(appStateNotifierProvider.notifier).authenticate();
            }
          }
        }
      } on FirebaseAuthException catch (e) {
        if (context.mounted) {
          String errorMessage;
          switch (e.code) {
            case 'email-already-in-use':
              errorMessage = LocaleKeys.emailAlreadyInUse.tr();
              break;
            case 'weak-password':
              errorMessage = LocaleKeys.weakPassword.tr();
              break;
            default:
              errorMessage = LocaleKeys.errorOcurred.tr();
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                errorMessage,
                style: SerManosTextStyle.body01().copyWith(color: SerManosColors.neutral0),
              ),
              backgroundColor: SerManosColors.error100,
            ),
          );
        }
      } finally {
        isLoading.value = false;
        ref.read(firebaseAnalyticsProvider).logSignUp(signUpMethod: 'email');
      }
    }

    return Scaffold(
      backgroundColor: SerManosColors.neutral0,
      body: Padding(
        padding: const EdgeInsets.only(
            top: 84, // 52 from header 32 vertical padding,
            left: 16,
            right: 16),
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
                  isSignUpButtonEnabled.value =
                      formKey.currentState?.validate() ?? false;
                },
                child: Column(
                  children: [
                    UtilTextInput(
                        label: LocaleKeys.name.tr(),
                        hintText: LocaleKeys.nameHint.tr(),
                        controller: nameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: Validator.apply(context, [
                          const RequiredValidation(),
                        ])),
                    const SizedBox(height: 24),
                    UtilTextInput(
                        label: LocaleKeys.lastName.tr(),
                        hintText: LocaleKeys.lastNameHint.tr(),
                        controller: lastNameController,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: Validator.apply(context, [
                          const RequiredValidation(),
                        ])),
                    const SizedBox(height: 24),
                    UtilTextInput(
                      label: LocaleKeys.email.tr(),
                      hintText: LocaleKeys.emailHint.tr(),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      validator: Validator.apply(context, [
                        const RequiredValidation(),
                        const EmailValidation()
                      ]),
                    ),
                    const SizedBox(height: 24),
                    PasswordInput(
                      label: LocaleKeys.password.tr(),
                      hintText: LocaleKeys.passwordHint.tr(),
                      controller: passwordController,
                      validator: Validator.apply(context, [
                        const RequiredValidation(),
                        const PasswordValidation()
                      ]),
                    ),
                    // So that the helper is visible when focused on password
                    const SizedBox(height: 16)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UtilFilledButton(
                isLoading: isLoading.value,
                onPressed: isSignUpButtonEnabled.value ? handleSignup : null,
                text: LocaleKeys.signUp.tr()),
            const SizedBox(height: 8),
            UtilTextButton(
              onPressed: () {
                context.replace('/login');
              },
              text: LocaleKeys.haveAccount.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
