import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/volunteer/presentation/volunteer_list.dart';
import 'package:ser_manos_mobile/volunteer/presentation/volunteer_map.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';

import '../../providers/service_providers.dart';


class VolunteerScreen extends HookConsumerWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMap = useState(false);

    void toggleMap() {
      showMap.value = !showMap.value;
    }

    final allVolunteerings = ref.watch(volunteeringsNotifierProvider);
    final currentUser = ref.watch(currentUserNotifierProvider);

    final volunteeringsNotifier = ref.read(volunteeringsNotifierProvider.notifier);
    final volunteeringService = ref.read(volunteeringServiceProvider);

    Future<void> loadVolunteerings() async {
      await for (var volunteerings in volunteeringService.fetchVolunteerings()) {
        volunteeringsNotifier.setVolunteerings(volunteerings);
      }
    }

    useEffect(() {
      loadVolunteerings();
      return null;
    }, []);

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
        : VolunteerListScreen(onIconPressed: toggleMap);
  }
}
