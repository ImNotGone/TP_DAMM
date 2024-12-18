import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/profile/presentation/profile_screen.dart';
import 'package:ser_manos_mobile/shared/tokens/text_style.dart';
import '../../shared/tokens/colors.dart';
import '../../translations/locale_keys.g.dart';
import '../../volunteer/presentation/volunteer_screen.dart';
import '../../news/presentation/news_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int _currentScreen = 0;

  final List<Widget> _screens = [
    const VolunteerScreen(),
    const ProfileScreen(),
    const NewsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: SerManosColors.secondary90,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logo_rectangular.png',
                  fit: BoxFit.cover, height: 25, width: 147),
            ],
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(52),
            child: Container(
              height: 52,
              color: SerManosColors.secondary100,
              child: TabBar(
                  labelColor: SerManosColors.neutral0,
                  unselectedLabelColor: SerManosColors.neutral25,
                  labelStyle: SerManosTextStyle.button(),
                  dividerColor: SerManosColors.secondary100,
                  indicator: const BoxDecoration(
                    color: SerManosColors.secondary200,
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.white, // White underline
                        width: 3.0,
                      ),
                    ),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: [
                    Tab(text: LocaleKeys.apply.tr()),
                    Tab(text: LocaleKeys.myProfile.tr()),
                    Tab(text: LocaleKeys.news.tr()),
                  ],
                  onTap: (index) {
                    setState(() {
                      _currentScreen = index;
                    });
                  },
            )
            ),
          )
        ),
        body: Container(
            color: SerManosColors.secondary10,
            child: _screens[_currentScreen]
        ),
      ),
    );
  }
}
