import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import '../../shared/molecules/buttons/text.dart';
import '../../shared/tokens/colors.dart';
import '../../shared/tokens/text_style.dart';

class PreLoginWelcome extends StatelessWidget {
  const PreLoginWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SerManosColors.neutral0,
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
                Text(AppLocalizations.of(context)!.preLoginWelcome, style: SerManosTextStyle.subtitle01(), textAlign: TextAlign.center,)
              ],
            ),
            const Spacer(),
            Column(
              children: [
                UtilFilledButton(
                    onPressed: () {
                      context.push('/login');
                    },
                    text: AppLocalizations.of(context)!.login
                ),
                const SizedBox(height: 8),
                UtilTextButton(
                    onPressed: () {
                      context.push('/sign_up');
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