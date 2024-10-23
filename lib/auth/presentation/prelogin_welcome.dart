import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/auth/presentation/signup.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import '../../shared/molecules/buttons/text.dart';
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
                UtilFilledButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                    },
                    text: AppLocalizations.of(context)!.login
                ),
                const SizedBox(height: 8),
                UtilTextButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const SignUpScreen()));
                    },
                    text: AppLocalizations.of(context)!.signUp
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}