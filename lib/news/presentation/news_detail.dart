import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos_mobile/providers/news_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../shared/molecules/buttons/filled.dart';
import '../../news/domain/news.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../shared/tokens/colors.dart';
import '../../shared/tokens/text_style.dart';

class NewsDetail extends HookConsumerWidget {
  final String newsId;

  const NewsDetail({super.key, required this.newsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final News? news = ref.read(newsNotifierProvider)?.firstWhere((news) => news.uid == newsId);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.news, style: const TextStyle(color: SerManosColors.neutral0),),
        centerTitle: true,
        leading: IconButton(
            onPressed: ()  => context.pop(),
            icon: const Icon(Icons.arrow_back),
            color: SerManosColors.neutral0
        ),
        backgroundColor: SerManosColors.secondary100,
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
              Text(news.subtitle, style: SerManosTextStyle.subtitle01().copyWith(
                  color: SerManosColors.secondary200,
              ),),
              const SizedBox(height: 16.0),
              Text(news.content, style: SerManosTextStyle.body01(),),
              const SizedBox(height: 16.0),
              Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.shareThisNote,
                      style: SerManosTextStyle.headline02(),
                    )
                ),
              const SizedBox(height: 16.0),
              UtilFilledButton(
                  onPressed: () async {
                    final img = await getNetworkImage(news.imageUrl);
                    Share.shareXFiles(
                      [img],
                      text: news.subtitle,
                    );
                  },
                  text: AppLocalizations.of(context)!.share
              ),
              const SizedBox(height: 32.0),
            ],
          )
      ),
    );
  }

  // https://stackoverflow.com/questions/63353484/flutter-network-image-to-file
  Future<XFile> getNetworkImage(String url) async {
    final response = await http.get(Uri.parse(url));
    final documentDirectory = await getApplicationDocumentsDirectory();
    final file = File('${documentDirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png');
    file.writeAsBytesSync(response.bodyBytes);
    return XFile(file.path);
  }
}
