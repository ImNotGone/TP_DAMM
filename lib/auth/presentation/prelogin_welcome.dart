import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import '../../shared/molecules/buttons/text.dart';

class PreLoginWelcome extends StatelessWidget {
  const PreLoginWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Image.asset('assets/logo_square.png', width: 150, height: 150),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.preLoginWelcome, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,)
              ],
            ),
            const Spacer(),
            Column(
              children: [
                UtilFilledButton(
                    onPressed: () {
                      context.go('/login');
                    },
                    text: AppLocalizations.of(context)!.login
                ),
                const SizedBox(height: 8),
                UtilTextButton(
                    onPressed: () {
                      context.go('/sign_up');
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