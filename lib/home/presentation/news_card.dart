import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../domain/news.dart';


class NewsCard extends StatelessWidget {
  final News news;

  const NewsCard({
    super.key,
    required this.news
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
                    Text(news.paper, style: Theme.of(context).textTheme.labelSmall,),
                    Text(news.title, style: Theme.of(context).textTheme.titleMedium,),
                    Text(news.subtitle, style: Theme.of(context).textTheme.bodySmall,),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                            onPressed: () {
                              context.push('/newsDetail/${news.uid}', extra: news.uid);
                            },
                            child: Text(
                              AppLocalizations.of(context)!.readMore,
                              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
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