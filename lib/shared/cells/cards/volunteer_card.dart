import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';
import '../../../auth/domain/app_user.dart';
import '../../../home/domain/volunteering.dart';
import '../../../providers/service_providers.dart';
import '../../../providers/user_provider.dart';
import '../../molecules/components/vacancies.dart';

class VolunteerCard extends HookConsumerWidget {
  final String volunteeringId;

  const VolunteerCard({
    super.key,
    required this.volunteeringId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userService = ref.read(userServiceProvider);

    final volunteering = ref.watch(volunteeringsNotifierProvider)?[volunteeringId];

    if (volunteering == null) {
      return const SizedBox.shrink();
    }

    Future<void> markAsFavorite() async {
      AppUser user = await userService.markVolunteeringAsFavourite(volunteeringId);
      ref.read(currentUserNotifierProvider.notifier).setUser(user);
      Volunteering updatedVolunteering = volunteering.copyWith(isFavourite: true);
      ref.read(volunteeringsNotifierProvider.notifier).updateVolunteering(updatedVolunteering);
    }

    Future<void> unmarkAsFavorite() async {
      AppUser user = await userService.unmarkVolunteeringAsFavourite(volunteeringId);
      ref.read(currentUserNotifierProvider.notifier).setUser(user);
      Volunteering updatedVolunteering = volunteering.copyWith(isFavourite: false);
      ref.read(volunteeringsNotifierProvider.notifier).updateVolunteering(updatedVolunteering);
    }

    return GestureDetector(
      onTap: () {
        context.push('/volunteering/$volunteeringId', extra: volunteeringId);
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
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xff666666)),
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
                            _buildIcon(
                              volunteering.isFavourite ? Icons.favorite : Icons.favorite_border,
                              volunteering.isFavourite ? unmarkAsFavorite : markAsFavorite,
                            ),
                            const SizedBox(width: 16),
                            _buildIcon(Icons.place, () {
                              // TODO: Handle location button press
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(IconData icon, VoidCallback? onPressed) {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        icon: Icon(icon),
        color: const Color(0xff14903f),
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }
}