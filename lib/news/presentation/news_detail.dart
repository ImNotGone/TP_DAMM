import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos_mobile/providers/firebase_providers.dart';
import 'package:ser_manos_mobile/providers/news_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/molecules/buttons/filled.dart';
import '../../news/domain/news.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../shared/tokens/colors.dart';
import '../../shared/tokens/text_style.dart';
import '../../translations/locale_keys.g.dart';

class NewsDetail extends HookConsumerWidget {
  final String newsId;

  const NewsDetail({super.key, required this.newsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsNotifier = ref.watch(newsNotifierProvider);
    final News? news =
        newsNotifier.value?.firstWhere((news) => news.uid == newsId);

    return (newsNotifier.isLoading || newsNotifier.isRefreshing)
        ? Scaffold(
            body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            backgroundColor: SerManosColors.neutral0,
            appBar: AppBar(
              title: Text(
                LocaleKeys.news.tr(),
                style: SerManosTextStyle.subtitle01()
                    .copyWith(color: SerManosColors.neutral0),
              ),
              centerTitle: true,
              leading: IconButton(
                  onPressed: () => context.go('/home'),
                  icon: const Icon(Icons.arrow_back),
                  color: SerManosColors.neutral0),
              backgroundColor: SerManosColors.secondary90,
            ),
            body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  children: [
                    const SizedBox(height: 24.0),
                    Text(news!.paper, style: SerManosTextStyle.overline()),
                    Text(news.title, style: SerManosTextStyle.headline02()),
                    const SizedBox(height: 16.0),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 160,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Image.network(
                          news.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      news.subtitle,
                      style: SerManosTextStyle.subtitle01().copyWith(
                        color: SerManosColors.secondary200,
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      news.content,
                      style: SerManosTextStyle.body01(),
                    ),
                    const SizedBox(height: 16.0),
                    Container(
                        alignment: Alignment.center,
                        child: Text(
                          LocaleKeys.shareThisNote.tr(),
                          style: SerManosTextStyle.headline02(),
                        )),
                    const SizedBox(height: 16.0),
                    UtilFilledButton(
                        onPressed: () async {
                          final img = await getNetworkImage(news.imageUrl);
                          Share.shareXFiles(
                            [img],
                            text:
                                '${news.subtitle} http://sermanos.app/newsDetail/${news.uid}',
                          );
                          ref.read(firebaseAnalyticsProvider).logShare(
                              contentType: 'news',
                              itemId: news.uid,
                              method: 'button');
                        },
                        text: LocaleKeys.share.tr()),
                    const SizedBox(height: 32.0),
                  ],
                )),
          );
  }

  // https://stackoverflow.com/questions/63353484/flutter-network-image-to-file
  Future<XFile> getNetworkImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File(
        '${documentDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png');
    file.writeAsBytesSync(response.bodyBytes);
    return XFile(file.path);
  }
}
