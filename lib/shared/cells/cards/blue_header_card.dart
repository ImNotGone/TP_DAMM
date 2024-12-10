import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';

import '../../tokens/text_style.dart';

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
      color: SerManosColors.neutral10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      elevation: 0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header azul
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: const BoxDecoration(
                color: SerManosColors.secondary25,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(4)
                )
            ),
            child: Text(
              title,
              style: SerManosTextStyle.subtitle01(),
            ),
          ),
          child,
        ],
      ),
    );
  }
}