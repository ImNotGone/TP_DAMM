import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos_mobile/news/application/news_service.dart';
import 'package:ser_manos_mobile/news/data/news_repository.dart';
import 'package:ser_manos_mobile/news/domain/news.dart';

import 'news_test.mocks.dart';

@GenerateMocks([NewsRepository])
void main() {
  late MockNewsRepository mockNewsRepository;
  late NewsService newsService;

  setUp(() {
    mockNewsRepository = MockNewsRepository();
    newsService = NewsService(mockNewsRepository);
  });

  group('NewsService', () {
    final newsItem = News(
      uid: 'n1',
      imageUrl: 'https://example.com/image.png',
      title: 'Breaking News',
      paper: 'Daily Times',
      subtitle: 'An important event',
      content: 'Detailed content about the news event.',
      creationDate: DateTime.now(),
    );

    test('fetchNews should call fetchNews on the repository and return a list of news', () async {
      when(mockNewsRepository.fetchNews())
          .thenAnswer((_) async => [newsItem]);

      final result = await newsService.fetchNews();

      expect(result, [newsItem]);
      verify(mockNewsRepository.fetchNews()).called(1);
    });
  });
}