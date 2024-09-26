import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/home/presentation/volunteering_card.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';

import 'map.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMap = useState(false);

    void toggleMap() {
      showMap.value = !showMap.value;
    }

    final allVolunteerings = ref.watch(volunteeringsProvider);

    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _SearchBar(onMapButtonPressed: toggleMap),
          const Padding(padding: EdgeInsets.all(8.0)),
          Expanded(
            child: showMap.value
                ? const MapSample()
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                        Text(AppLocalizations.of(context)!.volunteering,
                            style: const TextStyle(fontSize: 24.0)),
                        Expanded(
                            child: ListView.builder(
                          itemCount: allVolunteerings.length,
                          itemBuilder: (context, index) {
                            return VolunteeringCard(
                                volunteering: allVolunteerings[index]);
                          },
                        ))
                      ]),
          )
        ]));
  }
}

class _SearchBar extends HookWidget {
  final VoidCallback onMapButtonPressed;

  const _SearchBar({required this.onMapButtonPressed});

  @override
  Widget build(BuildContext context) {
    final showMapIcon = useState(true);

    void toggleMapIcon() {
      showMapIcon.value = !showMapIcon.value;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: (AppLocalizations.of(context)!.search),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            // TODO: check if color can come from theme
            icon: showMapIcon.value
                ? const Icon(Icons.map, color: Colors.green)
                : const Icon(Icons.menu, color: Colors.green),
            onPressed: () {
              onMapButtonPressed();
              toggleMapIcon();
            },
          ),
        ],
      ),
    );
  }
}
