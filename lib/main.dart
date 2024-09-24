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
          fontFamily: 'Roboto',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black,
            ),
            // Roboto Regular 24px
            headlineMedium: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w500, // Medium weight
              color: Colors.black,
            ),
            // Roboto Medium 20px
            titleMedium: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black,
            ),
            // Roboto Regular 16px
            bodyLarge: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black,
            ),
            // Roboto Regular 14px
            bodyMedium: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black,
            ),
            // Roboto Regular 12px
            bodySmall: TextStyle(
              fontSize: 12.0,
              fontWeight: FontWeight.w400, // Regular weight
              color: Colors.black54,
            ),
            labelLarge: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500, // Medium weight
              color: Colors.black,
            ),
            // Roboto Medium 14px
            // Roboto Regular 12px (for caption)
            labelSmall: TextStyle(
              fontSize: 10.0,
              fontWeight: FontWeight.w500,
              // Medium weight
              letterSpacing: 1.5,
              // Usually overlines have larger letter-spacing
              color: Colors.black,
            ), // Roboto Medium 10px
          ),
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue,
            brightness: Brightness.light,
            primary: Colors.blue,
            onPrimary: Colors.white,
            primaryContainer: Colors.blue.shade900,
            secondary: Colors.green,
            onSecondary: Colors.white,
            error: Colors.red,
            onError: Colors.white,
            surface: Colors.white,
            onSurface: Colors.black,
          ),
          useMaterial3: true,
        ),
        home: const Home());
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
              ]),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _SearchBar(),
            const Padding(padding: EdgeInsets.all(8.0)),
            Text(AppLocalizations.of(context)!.volunteering,
                style: const TextStyle(fontSize: 24.0)),
            Expanded(
                child: ListView(
              children: const [
                VolunteeringCard(
                    imageUrl: 'https://via.placeholder.com/400x200',
                    title: 'Un Techo Para mi País',
                    type: 'ACCIÓN SOCIAL',
                    vacancies: '10'),
                VolunteeringCard(
                    imageUrl: 'https://via.placeholder.com/400x200',
                    title: 'Manos caritativas',
                    type: 'ACCIÓN SOCIAL',
                    vacancies: '10'),
                VolunteeringCard(
                    imageUrl: 'https://via.placeholder.com/400x200',
                    title: 'Asociacion Conciencia',
                    type: 'ACCIÓN SOCIAL',
                    vacancies: '10'),
              ],
            ))
          ]),
        ),
      ),
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

class VolunteeringCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String type;
  final String vacancies;

  const VolunteeringCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.type,
      required this.vacancies});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Image section
          ClipRRect(
            child: Image.network(
              imageUrl,
              // Replace with the real image URL
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(type, style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 4),
                // Title Text
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                // Vacancy Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: Row(
                        children: <Widget>[
                          Text('${AppLocalizations.of(context)!.vacancies}:',
                              style: Theme.of(context).textTheme.bodyMedium),
                          Icon(
                            Icons.person,
                            size: 16,
                            color: Colors.blue[900],
                          ),
                          const SizedBox(width: 4),
                          Text(vacancies,
                              style: Theme.of(context).textTheme.titleMedium),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          color: Colors.green,
                          onPressed: () {
                            // TODO: Handle favorite button press
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.place),
                          color: Colors.green,
                          onPressed: () {
                            // TODO: Handle location button press
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
