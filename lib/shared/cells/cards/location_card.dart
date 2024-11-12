import 'package:flutter/material.dart';

import 'blue_header_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationCard extends StatelessWidget {
  final String address;

  const LocationCard({
    super.key,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return BlueHeaderCard(
      title: AppLocalizations.of(context)!.location,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(6),
              bottomRight: Radius.circular(6),
            ),
            child: Image.network(
              // TODO: revisar el height
              //height: 155,
              'https://staticmapmaker.com/img/google-placeholder.png',
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      AppLocalizations.of(context)!.address.toUpperCase(),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xff666666))
                  ),
                  Text(
                      address,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black)
                  ),
                ],
              ),
          )
        ],
      ),
    );
  }
}