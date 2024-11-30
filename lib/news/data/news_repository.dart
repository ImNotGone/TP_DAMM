import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/news.dart';

class NewsRepository{
  final FirebaseFirestore _firestore;

  NewsRepository(this._firestore);

  Future<List<News>> fetchNews() async {
    final newsJson = await _firestore.collection('news').get();
    List<News> news = [];
    for (var newsDoc in newsJson.docs) {
      final data = newsDoc.data();
      data['uid'] = newsDoc.id;
      news.add(News.fromJson(data));
    }
    return news;
  }
}