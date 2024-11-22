import 'package:flutter/material.dart';

import '../../tokens/colors.dart';
import 'blue_header_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationDetailCard extends StatelessWidget {
  final String address;

  const LocationDetailCard({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return BlueHeaderCard(
      title: AppLocalizations.of(context)!.location,
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)!.address.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: SerManosColors.neutral75)
                  ),
                  Text(
                      address,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: SerManosColors.neutral100)
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