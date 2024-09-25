import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/constants.dart';
import 'package:ser_manos_mobile/home/presentation/news_card.dart';
import 'volunteering_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentScreen = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const ProfileScreen(),
    const NewsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logo_rectangular.png',
                  fit: BoxFit.cover, height: 40.0),
            ],
          ),
          bottom: TabBar(
              labelColor: Theme.of(context).colorScheme.onPrimary,
              unselectedLabelColor: Theme.of(context).colorScheme.onPrimary,
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer, // Change this to your desired color
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(icon: Text(AppLocalizations.of(context)!.apply)),
                Tab(icon: Text(AppLocalizations.of(context)!.myProfile)),
                Tab(icon: Text(AppLocalizations.of(context)!.news)),
              ],
              onTap: (index) {
                  setState(() {
                    _currentScreen = index;
                  });
                },
              ),
        ),
        body: _screens[_currentScreen],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Text('//TODO REMOVE THIS, profile');
  }
}

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                NewsCard(news: news1),
                NewsCard(news: news2),
                NewsCard(news: news3),
                NewsCard(news: news4)
              ],
            )
        ),
      ],
      ),
    );
  }
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child:
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _SearchBar(),
        const Padding(padding: EdgeInsets.all(8.0)),
        Text(AppLocalizations.of(context)!.volunteering,
            style: const TextStyle(fontSize: 24.0)),
        Expanded(child: ListView(children: [
          VolunteeringCard(
            volunteering: volunteering1,
          ),
          VolunteeringCard(
            volunteering: volunteering2,
          ),
          VolunteeringCard(
            volunteering: volunteering3,
          ),
        ],))
      ]),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0.0),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: (AppLocalizations.of(context)!.search),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.map, color: Colors.green),
            onPressed: () {
              // TODO: agregar accion
            },
          ),
        ],
      ),
    );
  }
}