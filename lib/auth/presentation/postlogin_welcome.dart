import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import 'package:ser_manos_mobile/providers/is_logged_in_provider.dart';

import '../../shared/tokens/colors.dart';
import '../../shared/tokens/text_style.dart';

class PostLoginWelcome extends HookConsumerWidget {
  const PostLoginWelcome({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                Text(AppLocalizations.of(context)!.welcome, style: SerManosTextStyle.headline01()),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)!.postLoginWelcome, style: SerManosTextStyle.subtitle01(), textAlign: TextAlign.center,)
              ],
            ),
            const Spacer(),
            Column(
              children: [
                UtilFilledButton(
                  onPressed: () {
                    ref.read(isLoggedInNotifierProvider.notifier).logIn();
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