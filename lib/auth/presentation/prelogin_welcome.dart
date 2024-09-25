import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/auth/presentation/signup.dart';
import 'login.dart';

class PreLoginWelcome extends StatelessWidget {
  const PreLoginWelcome({super.key});

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
                Text(AppLocalizations.of(context)!.preLoginWelcome, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,)
              ],
            ),
            const Spacer(),
            Column(
              children: [
                SizedBox(
                  width: double.infinity, 
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary, 
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4), 
                      ),
                    ),
                    child: Text(AppLocalizations.of(context)!.login, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
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
                    child: Text(AppLocalizations.of(context)!.signUp, style: TextStyle(color: Theme.of(context).colorScheme.secondary)),
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