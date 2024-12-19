import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/router_provider.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/molecules/buttons/text.dart';
import '../../shared/tokens/colors.dart';
import '../../shared/tokens/text_style.dart';
import '../../translations/locale_keys.g.dart';

class PreLoginWelcome extends ConsumerWidget {
  const PreLoginWelcome({super.key});

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
                Text(LocaleKeys.preLoginWelcome.tr(), style: SerManosTextStyle.subtitle01(), textAlign: TextAlign.center,)
              ],
            ),
            const Spacer(),
            Column(
              children: [
                UtilFilledButton(
                    onPressed: () {
                      context.push('/login');
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setBool('hasSeenWelcomeScreen', true);
                      });
                      ref.read(hasSeenWelcomeScreenProvider.notifier).state = true;
                    },
                    text: LocaleKeys.login.tr()
                ),
                const SizedBox(height: 8),
                UtilTextButton(
                    onPressed: () {
                      context.push('/sign_up');
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setBool('hasSeenWelcomeScreen', true);
                      });
                      ref.read(hasSeenWelcomeScreenProvider.notifier).state = true;
                    },
                    text: LocaleKeys.signUp.tr()
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}