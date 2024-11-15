import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';
import 'package:ser_manos_mobile/shared/cells/cards/volunteer_card.dart';

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
        color: const Color(0xFFf3F9F5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  volunteering!.type.localizedName(context).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xff666666))
              ),
              Text(
                  volunteering.title,
                  style: Theme.of(context).textTheme.titleMedium
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