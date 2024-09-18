import 'package:flutter/material.dart';
// https://docs.flutter.dev/ui/accessibility-and-internationalization/internationalization
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ser Manos',
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
          primary: Colors.blue,
          onPrimary: Colors.white,
          secondary: Colors.green,
          onSecondary: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // Change the AppBar color here
          foregroundColor: Colors.white, // Change the AppBar text/icon color
        ),
      ),
      home: const Home()
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logo_rectangular.png',
                  fit: BoxFit.cover, height: 40.0),
            ],
          ),
          bottom: TabBar(tabs: [
            Tab(icon: Text(AppLocalizations.of(context)!.apply)),
            Tab(icon: Text(AppLocalizations.of(context)!.myProfile)),
            Tab(icon: Text(AppLocalizations.of(context)!.news)),
          ]),
        ),
        // TODO: remove this.
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(




                'You have pushed the button this many times:',
              ),
            ],
          ),
        ),
      ),
    );
  }
}