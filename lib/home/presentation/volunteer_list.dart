import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/home/domain/volunteering.dart';
import 'package:ser_manos_mobile/home/presentation/volunteer_map.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';
import 'package:ser_manos_mobile/shared/cells/cards/volunteer_card.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';
import 'package:ser_manos_mobile/shared/cells/cards/current_volunteer_card.dart';
import 'package:ser_manos_mobile/shared/molecules/components/no_volunteering.dart';

import '../../providers/service_providers.dart';
import '../../shared/molecules/inputs/search_bar.dart';

class VolunteerList extends HookConsumerWidget {
  const VolunteerList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMap = useState(false);
    final searchQuery = useState('');

    void toggleMap() {
      showMap.value = !showMap.value;
    }

    final volunteeringsNotifier =
        ref.read(volunteeringsNotifierProvider.notifier);
    final volunteeringService = ref.read(volunteeringServiceProvider);

    final allVolunteerings = ref.watch(volunteeringsNotifierProvider);
    final currentUser = ref.watch(currentUserNotifierProvider);

    Future<void> refreshVolunteerings() async {
      Map<String, Volunteering> volunteerings =
          await volunteeringService.fetchVolunteerings();
      for (String volunteeringId
          in currentUser?.favouriteVolunteeringIds ?? []) {
        if (volunteerings.containsKey(volunteeringId)) {
          volunteerings[volunteeringId]!.isFavourite = true;
        }
      }
      volunteeringsNotifier.setVolunteerings(volunteerings);
    }

    useEffect(() {
      // TODO: uncomment this line to upload volunteerings
      // volunteeringService.uploadVolunteerings();

      // Fetch volunteerings when the widget is built
      refreshVolunteerings();
      return null;
    }, []);

    final filteredVolunteerings = allVolunteerings?.values
        .where((volunteering) => volunteering.title
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()))
        .toList()
      ?..sort((a, b) => b.creationDate.compareTo(a.creationDate));

    if (currentUser == null ||
        allVolunteerings == null ||
        allVolunteerings.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return showMap.value
        ? VolunteerMapScreen(onIconPressed: toggleMap)
        : Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                UtilSearchBar(
                  onIconPressed: toggleMap,
                  onSearchChanged: (query) {
                    searchQuery.value = query;
                  },
                  icon: Icons.map,
                ),
                const SizedBox(
                  height: 32,
                ),
                if (currentUser.registeredVolunteeringId != null) ...[
                  Text(
                    AppLocalizations.of(context)!.yourActivity,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(
                          '/volunteering/${currentUser.registeredVolunteeringId}',
                          extra: currentUser.registeredVolunteeringId);
                    },
                    child: CurrrentVolunteerCard(
                      type: allVolunteerings[
                              currentUser.registeredVolunteeringId]!
                          .type
                          .localizedName(context),
                      title: allVolunteerings[
                              currentUser.registeredVolunteeringId]!
                          .title,
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
                Text(
                  AppLocalizations.of(context)!.volunteering,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refreshVolunteerings,
                    child: filteredVolunteerings == null ||
                            filteredVolunteerings.isEmpty
                        ? const NoVolunteering() // TODO: if searching it should be different
                        : ListView.builder(
                            itemCount: filteredVolunteerings.length,
                            itemBuilder: (context, index) {
                              return VolunteerCard(
                                volunteeringId:
                                    filteredVolunteerings[index].uid,
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
          );
  }
}
