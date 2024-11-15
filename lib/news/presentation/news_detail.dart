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

class NewsDetail extends HookConsumerWidget {
  final String newsId;

  const NewsDetail({super.key, required this.newsId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final News? news = ref.read(newsNotifierProvider)?.firstWhere((news) => news.uid == newsId);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.news, style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
        centerTitle: true,
        leading: IconButton(
            onPressed: ()  => context.pop(),
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).colorScheme.onSecondary
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView(
            children: [
              const SizedBox(height: 24.0),
              Text(news!.paper, style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xff666666)),),
              Text(news.title, style: Theme.of(context).textTheme.headlineMedium,),
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
              Text(news.subtitle, style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.secondaryContainer,
              ),),
              const SizedBox(height: 16.0),
              Text(news.content, style: Theme.of(context).textTheme.bodyLarge,),
              const SizedBox(height: 16.0),
              Container(
                    alignment: Alignment.center,
                    child: Text(
                      AppLocalizations.of(context)!.shareThisNote,
                      style: Theme.of(context).textTheme.headlineMedium,
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
