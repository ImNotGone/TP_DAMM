import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';


class PostLoginWelcome extends StatelessWidget {
  const PostLoginWelcome({super.key});

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
                Image.asset('assets/logo_square.png', width: 150, height: 150),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.welcome, style: Theme.of(context).textTheme.headlineLarge),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.postLoginWelcome, style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center,)
              ],
            ),
            const Spacer(),
            Column(
              children: [
                UtilFilledButton(
                  onPressed: () {
                    context.go('/home');
                    },
                  text: AppLocalizations.of(context)!.begin,
                ),
                const SizedBox(height: 56),
              ],
            ),
          ],
        ),
      ),
    );
  }

}