import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos_mobile/home/presentation/volunteering_card.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allVolunteerings = ref.watch(volunteeringsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SearchBar(),
        const Padding(padding: EdgeInsets.all(8.0)),
        Text(AppLocalizations.of(context)!.volunteering,
            style: const TextStyle(fontSize: 24.0)),
        Expanded(child: ListView.builder(
          itemCount: allVolunteerings.length,
          itemBuilder: (context, index) {
            return VolunteeringCard(volunteering: allVolunteerings[index]);
          },
        ))
      ]),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
            icon: const Icon(Icons.map, color: Colors.green),
            onPressed: () {
              // TODO: agregar accion
            },
          ),
        ],
      ),
    );
  }
}