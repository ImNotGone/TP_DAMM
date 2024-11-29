import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';
import 'package:ser_manos_mobile/shared/cells/cards/volunteer_card.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import 'package:ser_manos_mobile/shared/tokens/shadows.dart';

import '../../tokens/text_style.dart';

class CurrrentVolunteerCard extends HookConsumerWidget {
  final String id;

  const CurrrentVolunteerCard({super.key, required this.id});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volunteering = ref.read(volunteeringsNotifierProvider)?[id];

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: SerManosColors.primary5,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: SerManosColors.primary100, width: 2),
        boxShadow: SerManosShadows.shadow2
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  volunteering!.type.localizedName(context).toUpperCase(),
                  style: SerManosTextStyle.overline()
              ),
              Text(
                  volunteering.title,
                  style: SerManosTextStyle.subtitle01()
              ),
            ],
          ),
          buildIcon(Icons.place, () {
            openGoogleMaps(volunteering.location.latitude, volunteering.location.longitude);
          }),
        ],
      ),
    );
  }
}