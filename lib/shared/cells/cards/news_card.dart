import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../../news/domain/news.dart';
import '../../tokens/colors.dart';
import '../../tokens/shadows.dart';
import '../../tokens/text_style.dart';


class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({
    super.key,
    required this.news
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2),
          color: SerManosColors.neutral0,
          boxShadow: SerManosShadows.shadow2
      ),
      child: IntrinsicHeight(
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: 118,
                child: Image.network(
                  news.imageUrl,
                  fit: BoxFit.cover,
                  // somehow making the image smaller, makes it take the lowest available space
                  height: double.minPositive,
                ),
              ),
              Expanded(
                child: Padding(padding: const EdgeInsets.only(top: 16.0, left: 8.0, right: 8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(news.paper, style: SerManosTextStyle.overline()),
                      Text(news.title, style: SerManosTextStyle.subtitle01()),
                      Text(news.subtitle, style: SerManosTextStyle.body02().copyWith(color: SerManosColors.neutral75)),
                      Align(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                              onPressed: () {
                                context.push('/newsDetail/${news.uid}');
                              },
                              child: Text(
                                AppLocalizations.of(context)!.readMore,
                                style: SerManosTextStyle.button().copyWith(color: SerManosColors.primary100),
                              )
                          )
                      )
                    ],
                  ),
                ),
              ),
            ]
        ),
      ),
    );
  }
}