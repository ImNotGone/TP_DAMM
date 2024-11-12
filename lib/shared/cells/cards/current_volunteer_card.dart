import 'package:flutter/material.dart';

class CurrrentVolunteerCard extends StatelessWidget {
  final String type;
  final String title;

  const CurrrentVolunteerCard({super.key, required this.type, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        // TODO: primarySwatch 5
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
                type.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xff666666))
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium
                ),
            ],
          ),
          Icon(
            Icons.place,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
        ],
      ),
    );
  }
}
