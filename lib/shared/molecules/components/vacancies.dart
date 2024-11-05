import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Vacancies extends StatelessWidget {
  final int count;

  const Vacancies({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: count == 0? Colors.grey[300] : Colors.blue[100],
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Text(
                '${AppLocalizations.of(context)!.vacancies}:',
                style: Theme.of(context).textTheme.bodyMedium
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.person,
            size: 20,
            color: count == 0? const Color(0xFF6CB6F3) : Colors.blue[900],
          ),
          Text(
            // TODO: can this be aligned slightly up?
            count.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: count == 0? const Color(0xFF6CB6F3) : Colors.blue[900]
            ),
          )
        ],
      ),
    );
  }
}