import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/news_provider.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import '../../shared/cells/cards/news_card.dart';
import '../../shared/tokens/text_style.dart';
import '../../translations/locale_keys.g.dart';

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
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  backgroundColor: SerManosColors.neutral0,
                  onRefresh: ref.read(newsNotifierProvider.notifier).refreshNews,
                  child: !allNews.hasValue || allNews.value!.isEmpty
                      ? Center(
                          child: Text(
                            LocaleKeys.noNews.tr(),
                            style: SerManosTextStyle.subtitle01(),
                          )
                        )
                      : ListView.builder(
                          itemCount: allNews.value!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 8.0, bottom: 16.0),
                              child: NewsCard(news: allNews.value![index]),
                            );
                          },
                      ),
                ),
              ),
            ],
          ),
        )
      );
  }
}