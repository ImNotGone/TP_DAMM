import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import 'package:ser_manos_mobile/providers/app_state_provider.dart';

import '../../shared/tokens/colors.dart';
import '../../shared/tokens/text_style.dart';
import '../../translations/locale_keys.g.dart';

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
                Text(LocaleKeys.welcome.tr(), style: SerManosTextStyle.headline01()),
                const SizedBox(height: 16),
                Text(LocaleKeys.postLoginWelcome.tr(), style: SerManosTextStyle.subtitle01(), textAlign: TextAlign.center,)
              ],
            ),
            const Spacer(),
            Column(
              children: [
                UtilFilledButton(
                  onPressed: () {
                    ref.read(appStateNotifierProvider.notifier).authenticate();
                  },
                  text: LocaleKeys.begin.tr(),
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