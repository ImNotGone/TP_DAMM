import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/profile/presentation/profile_screen.dart';
import '../../shared/tokens/colors.dart';
import '../../volunteer/presentation/volunteer_list.dart';
import '../../news/presentation/news_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentScreen = 0;

  final List<Widget> _screens = [
    const VolunteerList(),
    const ProfileScreen(),
    const NewsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: SerManosColors.secondary100,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logo_rectangular.png',
                  fit: BoxFit.cover, height: 25, width: 147),
            ],
          ),
          bottom: TabBar(
            labelColor: SerManosColors.neutral0,
            unselectedLabelColor: SerManosColors.neutral0,
            indicator: const BoxDecoration(
              color: SerManosColors.secondary200, // Change this to your desired color
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
        body: Container(
            color: SerManosColors.secondary10,
            child: _screens[_currentScreen]
        ),
      ),
    );
  }
}
