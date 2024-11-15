import 'package:ser_manos_mobile/news/data/news_repository.dart';
import '../domain/news.dart';

class NewsService{
  final NewsRepository _newsRepository;

  NewsService(this._newsRepository);

  Future<List<News>> fetchNews() async {
    return _newsRepository.fetchNews();
  }

  // TODO: uncomment this method to upload news
  // void uploadNews() {
  //   _newsRepository.uploadNews();
  // }
}