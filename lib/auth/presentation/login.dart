import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/auth/application/user_service.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/password_input.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/text_input.dart';
import 'package:ser_manos_mobile/shared/tokens/text_style.dart';
import '../../providers/app_state_provider.dart';
import '../../providers/firebase_providers.dart';
import '../../providers/router_provider.dart';
import '../../shared/molecules/buttons/text.dart';
import '../../shared/molecules/inputs/validation/email_validation.dart';
import '../../shared/molecules/inputs/validation/password_validation.dart';
import '../../shared/molecules/inputs/validation/required_validation.dart';
import '../../shared/molecules/inputs/validation/validator.dart';
import '../../shared/tokens/colors.dart';
import '../../translations/locale_keys.g.dart';
import '../domain/app_user.dart';
final formKey = GlobalKey<FormState>();

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    final isLoginEnabled = useState(false);
    final isLoading = useState(false);

    final UserService userService = ref.watch(userServiceProvider);

    final emailFocusNode = useFocusNode();
    final passwordFocusNode = useFocusNode();

    Future<void> handleLogin() async {
      isLoading.value = true;
      try {
        await userService.signIn(
          emailController.text,
          passwordController.text,
        );

        if (userService.isLoggedIn()) {
          AppUser? appUser = await userService.getCurrentUser();

          String? oldToken = appUser?.fcmToken;
          String? newtoken = await ref.read(firebaseMessagingProvider).getToken();

          if(oldToken != newtoken){
            appUser?.fcmToken = newtoken;
            await userService.updateUser(appUser!);
          }

          ref.read(currentUserNotifierProvider.notifier).setUser(appUser);

          if (context.mounted) {
            if (!ref.read(hasSeenWelcomeScreenProvider)) {
              context.go('/post_login_welcome');
            } else {
              ref.read(appStateNotifierProvider.notifier).authenticate();
            }
          }
        }
      } on FirebaseAuthException {
        if(context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  LocaleKeys.wrongEmailOrPassword.tr(),
                  style: SerManosTextStyle.body01().copyWith(color: SerManosColors.neutral0),
                ),
                backgroundColor: SerManosColors.error100,
              ),
          );
        }
      } finally {
        isLoading.value = false;
        ref.read(firebaseAnalyticsProvider).logLogin();
      }
    }

    return Scaffold(
      backgroundColor: SerManosColors.neutral0,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
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
                    UtilTextInput(
                      focusNode: emailFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(passwordFocusNode);
                      },
                      label: LocaleKeys.email.tr(),
                      labelWhenEmpty: false,
                      hintText: LocaleKeys.email.tr(),
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
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
                      focusNode: passwordFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).unfocus();
                        if(isLoginEnabled.value) {
                          handleLogin();
                        }
                      },
                      label: LocaleKeys.password.tr(),
                      labelWhenEmpty: false,
                      hintText: LocaleKeys.password.tr(),
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
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              UtilFilledButton(
                isLoading: isLoading.value,
                onPressed: isLoginEnabled.value ? handleLogin : null,
                text: LocaleKeys.login.tr(),
              ),
              const SizedBox(height: 8),
              UtilTextButton(
                onPressed: () {
                  context.replace('/sign_up');
                },
                text: LocaleKeys.noAccount.tr(),
              ),
            ],
          ),
        ),
    );
  }
}
