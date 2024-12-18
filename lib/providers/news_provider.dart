import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import '../news/domain/news.dart';

part 'news_provider.g.dart';

@Riverpod(keepAlive: true)
class NewsNotifier extends _$NewsNotifier {
  @override
  Future<List<News>?> build() async {
    return await refreshNews();
  }

  Future<List<News>> refreshNews() async {
    final newsService = ref.read(newsServiceProvider);
    final news = await newsService.fetchNews();
    news.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    state = AsyncValue.data(news);
    return news;
  }

  void setNews(List<News> news) {
    state = AsyncValue.data(news);
  }

  void clearNews() {
    state = const AsyncValue.data(null);
  }
}
