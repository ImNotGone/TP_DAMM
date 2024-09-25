import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../domain/news.dart';
import 'news_detail.dart';


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
              child: Padding(padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(news.paper, style: Theme.of(context).textTheme.labelSmall,),
                    Text(news.title, style: Theme.of(context).textTheme.titleMedium,),
                    Text(news.subtitle, style: Theme.of(context).textTheme.bodySmall,),
                    Container(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => NewsDetail(news: news)));
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