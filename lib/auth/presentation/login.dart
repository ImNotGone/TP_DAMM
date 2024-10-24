import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/auth/application/auth_service.dart';
import 'package:ser_manos_mobile/auth/presentation/postlogin_welcome.dart';
import 'package:ser_manos_mobile/auth/presentation/signup.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import '../../shared/molecules/buttons/text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.email,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) => setState(() {}),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.password,
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
                    onPressed: (_emailController.text.isNotEmpty &&
                        _passwordController.text.isNotEmpty)
                        ? _handleLogin
                        : null,
                    text: AppLocalizations.of(context)!.login),
                const SizedBox(height: 8),
                UtilTextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()));
                    },
                    text: AppLocalizations.of(context)!.noAccount),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    final user = await _authService.signInWithEmailAndPassword(
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
