
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';

import '../../providers/service_providers.dart';
import '../../providers/user_provider.dart';
import '../../providers/volunteering_provider.dart';
import '../../shared/cells/cards/current_volunteer_card.dart';
import '../../shared/cells/cards/volunteer_card.dart';
import '../../shared/molecules/components/no_volunteering.dart';
import '../../shared/molecules/inputs/search_bar.dart';
import '../../shared/tokens/text_style.dart';
import '../domain/volunteering.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class VolunteerListScreen extends HookConsumerWidget {
  final void Function() onIconPressed;

  const VolunteerListScreen({
    super.key,
    required this.onIconPressed
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');

    final volunteeringsNotifier = ref.read(
        volunteeringsNotifierProvider.notifier);
    final volunteeringService = ref.read(volunteeringServiceProvider);

    final allVolunteerings = ref.watch(volunteeringsNotifierProvider);
    final currentUser = ref.watch(currentUserNotifierProvider);

    Future<void> refreshVolunteerings() async {
      Map<String, Volunteering> volunteerings = await volunteeringService.fetchVolunteerings();
      for (String volunteeringId in currentUser?.favouriteVolunteeringIds ?? []) {
        if (volunteerings.containsKey(volunteeringId)) {
          volunteerings[volunteeringId]!.isFavourite = true;
        }
      }
      volunteeringsNotifier.setVolunteerings(volunteerings);
    }

    final filteredVolunteerings = allVolunteerings?.values
        .where((volunteering) =>
        volunteering.title
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()))
        .toList()
      ?..sort((a, b) => b.creationDate.compareTo(a.creationDate));

    useEffect(() {
      refreshVolunteerings();
      return null;
    }, []);

    return Scaffold(
      backgroundColor: SerManosColors.secondary10,
      body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UtilSearchBar(
                  onIconPressed: onIconPressed,
                  onSearchChanged: (query) {
                    searchQuery.value = query;
                  },
                  icon: Icons.map,
                ),
                const SizedBox(
                  height: 32,
                ),
                if (currentUser?.registeredVolunteeringId != null) ...[
                  Text(
                    AppLocalizations.of(context)!.yourActivity,
                    style: SerManosTextStyle.headline01(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push('/volunteering/${currentUser.registeredVolunteeringId}');
                    },
                    child: CurrrentVolunteerCard(
                        id: currentUser!.registeredVolunteeringId!
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
                Text(
                  AppLocalizations.of(context)!.volunteering,
                  style: SerManosTextStyle.headline01(),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refreshVolunteerings,
                    child: filteredVolunteerings == null ||
                        filteredVolunteerings.isEmpty
                        ? const NoVolunteering() // TODO: if searching it should be different
                        : ListView.separated(
                            itemCount: filteredVolunteerings.length,
                            itemBuilder: (context, index) {
                              return VolunteerCard(
                              volunteeringId:
                              filteredVolunteerings[index].uid,
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(
                              height: 24,
                            ),
                          ),
                    ),
                  ),
              ],
            ),
          )
    );
  }
}