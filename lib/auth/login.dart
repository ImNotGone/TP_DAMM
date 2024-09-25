import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/auth/postlogin_welcome.dart';
import 'package:ser_manos_mobile/auth/signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;

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
                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
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
                SizedBox(
                  width: double.infinity,
                  // TODO: this is laggy, if I clear all contents, redrawing is kinda weird, maybe replace the whole button?
                  child: ElevatedButton(
                    onPressed: (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                        ? () {
                          // TODO: login!!!
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const PostLoginWelcome()));
                        }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey, // TODO: change to app colors?
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.login,
                        style: TextStyle(color: (_emailController.text.isNotEmpty && _passwordController.text.isNotEmpty)
                            ? Theme.of(context).colorScheme.onPrimary
                            : Colors.grey[600], // TODO: change to app colors?
                           )),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                    },
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.noAccount,
                        style: TextStyle(color: Theme
                            .of(context)
                            .colorScheme
                            .secondary)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}