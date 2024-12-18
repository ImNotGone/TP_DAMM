import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ser_manos_mobile/shared/cells/cards/blue_header_card.dart';
import 'package:ser_manos_mobile/shared/cells/cards/info_card.dart';

void main() {
  testWidgets('enabled', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: InfoCard(
              title: 'Card Title',
              label1: 'Label 1',
              content1: 'Content for label 1',
              label2: 'Label 2',
              content2: 'Content for label 2',
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expectLater(
      find.byType(InfoCard),
      matchesGoldenFile('goldens/info_card.png'),
    );
  }, tags: ['golden']);

  testWidgets('enabled', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: BlueHeaderCard(
              title: 'Card Title',
              child: Text('Example'),
            ),
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expectLater(
      find.byType(BlueHeaderCard),
      matchesGoldenFile('goldens/blue_header_card.png'),
    );
  }, tags: ['golden']);
}
