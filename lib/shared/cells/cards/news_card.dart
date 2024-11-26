import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../news/domain/news.dart';
import '../../tokens/colors.dart';
import '../../tokens/text_style.dart';


class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({
    super.key,
    required this.news
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: SerManosColors.neutral0,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(news.imageUrl,
                height:156,
                width: 118,
                fit: BoxFit.cover,
          ),
          Expanded(
              child: Padding(padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(news.paper, style: SerManosTextStyle.overline()),
                    Text(news.title, style: SerManosTextStyle.subtitle01()),
                    Text(news.subtitle, style: SerManosTextStyle.overline()),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                            onPressed: () {
                              context.push('/newsDetail/${news.uid}', extra: news.uid);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.readMore,
                              style: const TextStyle(color: SerManosColors.primary100),
                            )
                          )
                    )
                  ],
              ),
            ),
          ),
        ]
      ),
    );
  }
}