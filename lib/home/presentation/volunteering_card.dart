import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ser_manos_mobile/home/domain/volunteering.dart';
import 'package:ser_manos_mobile/shared/molecules/components/vacancies.dart';

class VolunteeringCard extends StatelessWidget {
  final Volunteering volunteering;

  const VolunteeringCard({
    super.key,
    required this.volunteering,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/volunteering/${volunteering.uid}', extra: volunteering.uid);
      },
      child: Card(
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
                    volunteering.type.localizedName(context),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const SizedBox(height: 4),
                  // Title Text
                  Text(
                    volunteering.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // Vacancy Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Vacancies(count: volunteering.vacancies),
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
      ),
    );
  }
}