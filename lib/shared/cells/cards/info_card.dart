import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/cells/cards/blue_header_card.dart';

import '../../tokens/text_style.dart';

//TODO: revisar size
class InfoCard extends StatelessWidget {
  final String title;
  final String label1;
  final String content1;
  final String label2;
  final String content2;

  const InfoCard({
    super.key,
    required this.title,
    required this.label1,
    required this.content1,
    required this.label2,
    required this.content2
  });

  @override
  Widget build(BuildContext context) {
    return BlueHeaderCard(
      title: title,
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label1.toUpperCase(), style: SerManosTextStyle.overline()),
              Text(content1, style: SerManosTextStyle.body01()),
              const SizedBox(height: 8),
              Text(label2.toUpperCase(), style: SerManosTextStyle.overline()),
              Text(content2, style: SerManosTextStyle.body01()),
            ],
        ),
      ),
    );
  }
}