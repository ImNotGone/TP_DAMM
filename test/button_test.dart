import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/floating.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/text.dart';

void main() {
  // Group tests by button type for better readability
  group('UtilFilledButton Golden Tests', () {
    testWidgets('enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilFilledButton(
                onPressed: () {},
                text: 'test',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilFilledButton),
        matchesGoldenFile('goldens/util_filled_button_enabled.png'),
      );
    });

    testWidgets('disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilFilledButton(
                onPressed: null,
                text: 'test',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilFilledButton),
        matchesGoldenFile('goldens/util_filled_button_disabled.png'),
      );
    });
  });

  group('UtilShortButton Golden Tests', () {
    testWidgets('enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilShortButton(
                onPressed: () {},
                text: 'test',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilShortButton),
        matchesGoldenFile('goldens/util_short_button_enabled.png'),
      );
    });

    testWidgets('disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilShortButton(
                onPressed: null,
                text: 'test',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilShortButton),
        matchesGoldenFile('goldens/util_short_button_disabled.png'),
      );
    });
  });

  group('UtilTinyShortButton Golden Tests', () {
    testWidgets('enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilTinyShortButton(
                onPressed: () {},
                text: 'test',
                icon: Icons.add,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilTinyShortButton),
        matchesGoldenFile('goldens/util_tiny_short_button_enabled.png'),
      );
    });

    testWidgets('disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilTinyShortButton(
                onPressed: null,
                text: 'test',
                icon: Icons.add,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilTinyShortButton),
        matchesGoldenFile('goldens/util_tiny_short_button_disabled.png'),
      );
    });
  });

  group('UtilFloatingButton Golden Tests', () {
    testWidgets('enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilFloatingButton(
                onPressed: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilFloatingButton),
        matchesGoldenFile('goldens/util_floating_button_enabled.png'),
      );
    });

    testWidgets('disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilFloatingButton(
                onPressed: null,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilFloatingButton),
        matchesGoldenFile('goldens/util_floating_button_disabled.png'),
      );
    });
  });

  group('UtilTextButton Golden Tests', () {
    testWidgets('enabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilTextButton(
                onPressed: () {},
                text: 'test',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilTextButton),
        matchesGoldenFile('goldens/util_text_button_enabled.png'),
      );
    });

    testWidgets('disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: UtilTextButton(
                onPressed: null,
                text: 'test',
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(UtilTextButton),
        matchesGoldenFile('goldens/util_text_button_disabled.png'),
      );
    });
  });
}
