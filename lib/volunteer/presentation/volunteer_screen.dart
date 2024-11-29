import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/volunteer/presentation/volunteer_list.dart';
import 'package:ser_manos_mobile/volunteer/presentation/volunteer_map.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';

import '../../providers/service_providers.dart';


class VolunteerScreen extends HookConsumerWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMap = useState(false);
    final isLoading = useState(true);

    void toggleMap() {
      showMap.value = !showMap.value;
    }

    final volunteeringsNotifier = ref.read(volunteeringsNotifierProvider.notifier);
    final volunteeringService = ref.read(volunteeringServiceProvider);

    Future<void> loadVolunteerings() async {
      await for (var volunteerings in volunteeringService.fetchVolunteerings()) {
        volunteeringsNotifier.setVolunteerings(volunteerings);
        isLoading.value = false;
      }
    }

    useEffect(() {
      loadVolunteerings();
      return null;
    }, []);

    return isLoading.value
            ? Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                )
              )
            : showMap.value
              ? VolunteerMapScreen(onIconPressed: toggleMap)
              : VolunteerListScreen(onIconPressed: toggleMap);
  }
}
