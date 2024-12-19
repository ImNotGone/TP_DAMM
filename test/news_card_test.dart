import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:ser_manos_mobile/news/domain/news.dart';
import 'package:ser_manos_mobile/shared/cells/cards/news_card.dart';

void main() {
  testWidgets('NewsCard golden test', (WidgetTester tester) async {
    final news = News(
      uid: '1',
      title: 'Test News Title',
      subtitle: 'Test News Subtitle',
      paper: 'Test Paper',
      imageUrl: 'https://www.google.com/url?sa=i&url=https%3A%2F%2Fwww.youtube.com%2F%40flutterdev&psig=AOvVaw1vD5MkaK41emnWQkh_szhk&ust=1734657504952000&source=images&cd=vfe&opi=89978449&ved=0CBQQjRxqFwoTCJCsp_vUsooDFQAAAAAdAAAAABAE',
      creationDate: DateTime.now(),
      content: 'test',
    );

    await mockNetworkImagesFor(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: NewsCard(news: news),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expectLater(
        find.byType(NewsCard),
        matchesGoldenFile('goldens/news_card_golden.png'),
      );
    });
  }, tags: ['golden']);
}