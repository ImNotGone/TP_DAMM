import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/auth/presentation/login.dart';
import 'package:ser_manos_mobile/auth/presentation/postlogin_welcome.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import '../../shared/molecules/buttons/text.dart';

import 'package:ser_manos_mobile/auth/application/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
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
                      controller: _nameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.name),
                        hintText: AppLocalizations.of(context)!.nameExample,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _lastNameController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.lastName),
                        hintText: AppLocalizations.of(context)!.lastNameExample,
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.email),
                        hintText: AppLocalizations.of(context)!.emailExample,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        label: Text(AppLocalizations.of(context)!.password),
                        hintText: AppLocalizations.of(context)!.passwordExample,
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      obscureText: _obscurePassword,
                      onChanged: (value) => setState(() {}),
                    ),
                  ],
                ),
              ],
            ),
            const Spacer(),
            Column(
              children: [
                UtilFilledButton(
                    onPressed: (_nameController.text.isNotEmpty &&
                            _lastNameController.text.isNotEmpty &&
                            _emailController.text.isNotEmpty &&
                            _passwordController.text.isNotEmpty)
                        ? _handleSignup
                        : null,
                    text: AppLocalizations.of(context)!.signUp),
                const SizedBox(height: 8),
                UtilTextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
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

  //TODO: Migrate to router and reutilize logic shared with login
  Future<void> _handleSignup() async {
    final user = await _authService.signUpWithEmailAndPassword(
      _emailController.text,
      _passwordController.text,
    );

    if (user != null) {
      _navigateToWelcome();
    } else {
      log('Login failed');
      // Handle login failure (e.g., show a snackbar or dialog)
    }
  }

  void _navigateToWelcome() {
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PostLoginWelcome()),
      );
    }
  }
}
