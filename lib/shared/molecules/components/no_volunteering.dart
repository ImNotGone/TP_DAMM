import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';

import '../../../translations/locale_keys.g.dart';
import '../../tokens/text_style.dart';

class NoVolunteering extends StatelessWidget {
  final bool isSearching;

  const NoVolunteering({
    super.key,
    required this.isSearching
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        color: SerManosColors.neutral0,
      ),
      child: Text(
        isSearching
            ? LocaleKeys.noSearchVolunteering.tr()
            : LocaleKeys.noVolunteering.tr(),
        textAlign: TextAlign.center,
        style: SerManosTextStyle.subtitle01(),
      ),
    );
  }
}