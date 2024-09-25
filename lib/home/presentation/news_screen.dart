import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ser_manos_mobile/providers/news_provider.dart';
import '../domain/news.dart';
import 'news_card.dart';

class NewsScreen extends ConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<News> allNews = ref.watch(newsProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
              child: ListView.builder(
                itemCount: allNews.length,
                itemBuilder: (context, index) {
                  return NewsCard(news: allNews[index]);
                },
              )
          ),
        ],
      ),
    );
  }
}
