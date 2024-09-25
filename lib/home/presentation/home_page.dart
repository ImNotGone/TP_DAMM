import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/home/presentation/profile_screen.dart';
import 'home_screen.dart';
import 'news_screen.dart';

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
