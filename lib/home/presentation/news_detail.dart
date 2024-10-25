import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import '../../shared/molecules/buttons/filled.dart';
import '../domain/news.dart';

class NewsDetail extends StatelessWidget {
  final News news;
  const NewsDetail({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.news, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        centerTitle: true,
        leading: IconButton(
            onPressed: ()  => context.pop(),
            icon: const Icon(Icons.arrow_back),
            color: Theme.of(context).colorScheme.onPrimary
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(news.paper, style: Theme.of(context).textTheme.labelSmall,),
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
                color: Theme.of(context).colorScheme.primary
              ),),
              const SizedBox(height: 16.0),
              Text(news.content, style: Theme.of(context).textTheme.bodyLarge,),
              const SizedBox(height: 16.0),
              // TODO: En las que no tienen content los botones deberian ir al fondo???
              Padding(padding: const EdgeInsets.all(4.0),
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    AppLocalizations.of(context)!.shareThisNote,
                    style: Theme.of(context).textTheme.headlineMedium,
                  )
                ),
              ),
              UtilFilledButton(
                  onPressed: () {
                    // TODO: SHARE NEWS
                  },
                  text: AppLocalizations.of(context)!.share
              )
            ],
          )
      ),
    );
  }}