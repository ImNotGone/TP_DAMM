import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import 'package:ser_manos_mobile/translations/locale_keys.g.dart';

import '../../providers/user_provider.dart';
import '../../providers/volunteering_provider.dart';
import '../../shared/cells/cards/current_volunteer_card.dart';
import '../../shared/cells/cards/volunteer_card.dart';
import '../../shared/molecules/components/no_volunteering.dart';
import '../../shared/molecules/inputs/search_bar.dart';
import '../../shared/tokens/text_style.dart';

class VolunteerListScreen extends HookConsumerWidget {
  final void Function() onIconPressed;

  const VolunteerListScreen({super.key, required this.onIconPressed});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchQuery = useState('');

    final allVolunteerings = ref.watch(volunteeringsNotifierProvider);
    final currentUser = ref.watch(currentUserNotifierProvider);

    final filteredVolunteerings = allVolunteerings.value
        ?.values.where((volunteering) => volunteering.title
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()))
        .toList()
      ?..sort((a, b) => b.creationDate.compareTo(a.creationDate));

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
                if (currentUser?.registeredVolunteeringId != null && filteredVolunteerings != null && filteredVolunteerings.isNotEmpty) ...[
                  Text(
                    LocaleKeys.yourActivity.tr(),
                    style: SerManosTextStyle.headline01(),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  GestureDetector(
                    onTap: () {
                      context.push(
                          '/volunteering/${currentUser.registeredVolunteeringId}');
                    },
                    child: CurrentVolunteerCard(
                        id: currentUser!.registeredVolunteeringId!),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                ],
                Text(
                  LocaleKeys.volunteering.tr(),
                  style: SerManosTextStyle.headline01(),
                ),
                const SizedBox(height: 16),
                filteredVolunteerings == null || filteredVolunteerings.isEmpty
                    ? NoVolunteering(
                        isSearching: searchQuery.value.isNotEmpty,
                      )
                    : Expanded(
                        child: ListView.separated(
                          itemCount: filteredVolunteerings.length,
                          itemBuilder: (context, index) {
                            return VolunteerCard(
                              volunteeringId: filteredVolunteerings[index].uid,
                            );
                          },
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 24,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
  }
}
