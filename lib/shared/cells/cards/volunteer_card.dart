import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../auth/domain/app_user.dart';
import '../../../providers/service_providers.dart';
import '../../../providers/user_provider.dart';
import '../../molecules/components/vacancies.dart';
import '../../tokens/colors.dart';
import '../../tokens/text_style.dart';

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
      volunteering.isFavourite = true;
      try{
        AppUser user = await userService.markVolunteeringAsFavourite(volunteeringId);
        ref.read(currentUserNotifierProvider.notifier).setUser(user);
      }
      catch (e) {
        log(e.toString());
        volunteering.isFavourite = false;
      }
    }

    Future<void> unmarkAsFavorite() async {
      volunteering.isFavourite = false;
      try{
        AppUser user = await userService.unmarkVolunteeringAsFavourite(volunteeringId);
        ref.read(currentUserNotifierProvider.notifier).setUser(user);
      }catch(e){
        log(e.toString());
        volunteering.isFavourite = true;
      }
    }

    return GestureDetector(
      onTap: () {
        context.push('/volunteering/$volunteeringId');
      },
      child: Card(
        elevation: 4,
        color: SerManosColors.neutral0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image section
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(2),
                topRight: Radius.circular(2),
              ),
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
                    style: SerManosTextStyle.overline(),
                  ),
                  // Title Text
                  Text(
                    volunteering.title,
                    style: SerManosTextStyle.subtitle01(),
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
                            buildIcon(
                              volunteering.isFavourite ? Icons.favorite : Icons.favorite_border,
                              volunteering.isFavourite ? unmarkAsFavorite : markAsFavorite,
                            ),
                            const SizedBox(width: 16),
                            buildIcon(Icons.place, () {
                              openGoogleMaps(volunteering.location.latitude, volunteering.location.longitude);
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
}

void openGoogleMaps(double latitude, double longitude) async {
  final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

Widget buildIcon(IconData icon, VoidCallback? onPressed) {
  return SizedBox(
    width: 24,
    height: 24,
    child: IconButton(
      icon: Icon(icon),
      color: SerManosColors.primary100,
      onPressed: onPressed,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
    ),
  );
}