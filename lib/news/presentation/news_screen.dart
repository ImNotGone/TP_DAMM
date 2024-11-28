import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/news_provider.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import '../../shared/cells/cards/news_card.dart';

class NewsScreen extends HookConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsNotifier = ref.read(newsNotifierProvider.notifier);
    final newsService = ref.read(newsServiceProvider);
    final allNews = ref.watch(newsNotifierProvider);

    Future<void> refreshNews() async {
      await newsService.fetchNews().then((news) {
        news.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        newsNotifier.setNews(news);
      });
    }

    useEffect(() {
      refreshNews();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: SerManosColors.secondary10,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: refreshNews,
                child: allNews == null || allNews.isEmpty
                    ? const Center(child: Text('No news available'))
                    : ListView.separated(
                        itemCount: allNews.length,
                        itemBuilder: (context, index) {
                          return NewsCard(news: allNews[index]);
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                          height: 24,
                        ),
                    ),
              ),
            ),
          ],
        ),
      )
    );
  }
}