import 'package:flutter/material.dart';

class BlueHeaderCard extends StatelessWidget {
  final String title;
  final Widget child;

  const BlueHeaderCard({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      // TODO: neutralSwatch 10?
      color: const Color(0xFFFAFAFA),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header azul
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryFixed,
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(4)
                )
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          child,
        ],
      ),
    );
  }
}