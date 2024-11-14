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
import '../../providers/user_provider.dart';
import '../../shared/molecules/buttons/text.dart';
import '../domain/app_user.dart';

class SignUpScreen extends HookConsumerWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nameController = useTextEditingController();
    final lastNameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);

    // State to track if the button should be enabled or not
    final isSignUpButtonEnabled = useState(false);

    final UserService userService = ref.watch(userServiceProvider);

    // Function to check if all fields are filled
    void checkFields() {
      if (nameController.text.isNotEmpty &&
          lastNameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty) {
        isSignUpButtonEnabled.value = true;
      } else {
        isSignUpButtonEnabled.value = false;
      }
    }

    // Add listeners to each text controller
    useEffect(() {
      nameController.addListener(checkFields);
      lastNameController.addListener(checkFields);
      emailController.addListener(checkFields);
      passwordController.addListener(checkFields);

      // Clean up the listeners when the widget is disposed
      return () {
        nameController.removeListener(checkFields);
        lastNameController.removeListener(checkFields);
        emailController.removeListener(checkFields);
        passwordController.removeListener(checkFields);
      };
    }, []);

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
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextInput(
                                label: AppLocalizations.of(context)!.name,
                                hintText: AppLocalizations.of(context)!.nameHint,
                                controller: nameController
                            ),
                            const SizedBox(height: 16),
                            TextInput(
                                label: AppLocalizations.of(context)!.lastName,
                                hintText: AppLocalizations.of(context)!.lastNameHint,
                                controller: lastNameController
                            ),
                            const SizedBox(height: 16),
                            TextInput(
                              label: AppLocalizations.of(context)!.email,
                              hintText: AppLocalizations.of(context)!.emailHint,
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(height: 16),
                            TextField(
                              controller: passwordController,
                              decoration: InputDecoration(
                                floatingLabelBehavior: FloatingLabelBehavior.always,
                                label: Text(AppLocalizations.of(context)!.password),
                                hintText: AppLocalizations.of(context)!.passwordHint,
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