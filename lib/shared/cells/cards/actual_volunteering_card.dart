import 'package:flutter/material.dart';

class ActualVolunteeringCard extends StatelessWidget {
  final String type;
  final String title;

  const ActualVolunteeringCard({super.key, required this.type, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFf3F9F5), // light greenish background color
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF14903f), width: 2), // green border color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                type.toUpperCase(),
                style: Theme.of(context).textTheme.labelSmall
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium
                ),
            ],
          ),
          const Icon(
            Icons.place,
            color: Color(0xFF14903f), // green icon color
            size: 24,
          ),
        ],
      ),
    );
  }
}
