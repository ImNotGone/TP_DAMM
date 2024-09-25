import 'package:flutter/material.dart';
import '../../constants.dart';
import 'news_card.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
              child: ListView(
                children: [
                  NewsCard(news: news1),
                  NewsCard(news: news2),
                  NewsCard(news: news3),
                  NewsCard(news: news4)
                ],
              )
          ),
        ],
      ),
    );
  }
}
