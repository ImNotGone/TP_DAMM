import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';

class Vacancies extends StatelessWidget {
  final int count;

  const Vacancies({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: BoxDecoration(
        color: count == 0? SerManosColors.neutral25 : SerManosColors.secondary25,
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
            color: count == 0? SerManosColors.secondary80 : SerManosColors.secondary200,
          ),
          Text(
            // TODO: can this be aligned slightly up?
            count.toString(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: count == 0? SerManosColors.secondary80 : SerManosColors.secondary200
            ),
          )
        ],
      ),
    );
  }
}