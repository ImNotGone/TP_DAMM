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
                height: 138,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    volunteering.type.localizedName(context).toUpperCase(),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  // Title Text
                  Text(
                    volunteering.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // Vacancy Row
                  const SizedBox(height: 4),
                  SizedBox(
                    height: 28,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Vacancies(count: volunteering.vacancies),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            _buildIcon(Icons.favorite_border, () {
                              // TODO: Handle favorite button press
                            }),
                            const SizedBox(width: 16,),
                            _buildIcon(Icons.place, () {
                              // TODO: Handle location button press
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8,)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(
      IconData icon,
      VoidCallback? onPressed
      ) {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        icon: Icon(icon,),
        color: Colors.green,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}