import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/home/presentation/volunteering_card.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';
import 'package:ser_manos_mobile/shared/molecules/components/no_volunteering.dart';

import '../../providers/service_providers.dart';
import 'map.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMap = useState(false);
    final searchController = useTextEditingController();
    final searchQuery = useState('');

    void toggleMap() {
      showMap.value = !showMap.value;
    }

    final volunteeringsNotifier = ref.read(volunteeringsNotifierProvider.notifier);
    final volunteeringService = ref.read(volunteeringServiceProvider);
    final allVolunteerings = ref.watch(volunteeringsNotifierProvider);

    Future<void> refreshVolunteerings() async {
      await volunteeringService.fetchVolunteerings().then((volunteerings) {
        volunteerings.sort((a, b) => b.creationDate.compareTo(a.creationDate));
        volunteeringsNotifier.setVolunteerings(volunteerings);
      });
    }

    useEffect(() {
      // TODO: uncomment this line to upload volunteerings
      // volunteeringService.uploadVolunteerings();

      // Fetch volunteerings when the widget is built
      refreshVolunteerings();
      return null;
    }, []);

    final filteredVolunteerings = allVolunteerings?.where((volunteering) {
      return volunteering.title.toLowerCase().contains(searchQuery.value.toLowerCase());
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SearchBar(
            onMapButtonPressed: toggleMap,
            searchController: searchController,
            onSearchChanged: (query) {
              searchQuery.value = query;
            },
          ),
          const Padding(padding: EdgeInsets.all(8.0)),
          Expanded(
            child: showMap.value
                ? const Map()
                : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.volunteering,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: refreshVolunteerings,
                    child: filteredVolunteerings == null || filteredVolunteerings.isEmpty
                        ? const NoVolunteering()
                        : ListView.builder(
                      itemCount: filteredVolunteerings.length,
                      itemBuilder: (context, index) {
                        return VolunteeringCard(
                          volunteering: filteredVolunteerings[index],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends HookWidget {
  final VoidCallback onMapButtonPressed;
  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  const _SearchBar({
    required this.onMapButtonPressed,
    required this.searchController,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    final showMapIcon = useState(true);

    void toggleMapIcon() {
      showMapIcon.value = !showMapIcon.value;
    }

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
              controller: searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.search,
                border: InputBorder.none,
              ),
              onChanged: onSearchChanged,
            ),
          ),
          IconButton(
            icon: showMapIcon.value
                ? const Icon(Icons.map, color: Colors.green)
                : const Icon(Icons.menu, color: Colors.green),
            onPressed: () {
              onMapButtonPressed();
              toggleMapIcon();
            },
          ),
        ],
      ),
    );
  }
}