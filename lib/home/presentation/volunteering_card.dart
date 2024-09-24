import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/home/domain/volunteering.dart';


class VolunteeringCard extends StatelessWidget {
  final Volunteering volunteering;

  const VolunteeringCard({
    super.key,
    required this.volunteering
  });

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
              volunteering.imageUrl,
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
                Text(
                    volunteering.type,
                    style: Theme.of(context).textTheme.labelSmall
                ),
                const SizedBox(height: 4),
                // Title Text
                Text(
                    volunteering.title,
                    style: Theme.of(context).textTheme.titleMedium
                ),
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
                          Text(
                              volunteering.vacancies.toString(),
                              style: Theme.of(context).textTheme.titleMedium
                          ),
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