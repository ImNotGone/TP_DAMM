import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../news/domain/news.dart';

part 'news_provider.g.dart';

@Riverpod(keepAlive: true)
class NewsNotifier extends _$NewsNotifier {
  @override
  List<News>? build() {
    return null;
  }

  void setNews(List<News> news) {
    state = news;
  }

  void clearNews() {
    state = null;
  }
}
