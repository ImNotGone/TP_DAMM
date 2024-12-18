import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../translations/locale_keys.g.dart';
import '../../tokens/colors.dart';
import '../../tokens/text_style.dart';
import 'blue_header_card.dart';

class LocationDetailCard extends StatelessWidget {
  final String address;

  const LocationDetailCard({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return BlueHeaderCard(
      title: LocaleKeys.location.tr(),
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      LocaleKeys.address.tr().toUpperCase(),
                      style: SerManosTextStyle.overline()
                  ),
                  Text(
                      address,
                      style: SerManosTextStyle.body01()
                  ),
                ],
              ),
              const SizedBox(
                width: 24,
                height: 24,
                child: Icon(Icons.place,
                  color: SerManosColors.primary100,
                ),
              )
            ],
          )
      )
    );
  }
}