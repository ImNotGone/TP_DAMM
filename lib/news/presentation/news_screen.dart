import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/news_provider.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import '../../shared/cells/cards/news_card.dart';
import '../../shared/tokens/text_style.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NewsScreen extends HookConsumerWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allNews = ref.watch(newsNotifierProvider);

    return (allNews.isLoading || allNews.isRefreshing)
        ? Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            )
          )
        :
      Scaffold(
      backgroundColor: SerManosColors.secondary10,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                backgroundColor: SerManosColors.neutral0,
                onRefresh: ref.read(newsNotifierProvider.notifier).refreshNews,
                child: !allNews.hasValue || allNews.value!.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(context)!.noNews,
                          style: SerManosTextStyle.subtitle01(),
                        )
                      )
                    : ListView.separated(
                        itemCount: allNews.value!.length,
                        itemBuilder: (context, index) {
                          return NewsCard(news: allNews.value![index]);
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