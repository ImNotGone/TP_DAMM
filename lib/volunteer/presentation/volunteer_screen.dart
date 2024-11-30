import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/volunteer/domain/volunteering.dart';
import 'package:ser_manos_mobile/volunteer/presentation/volunteer_list.dart';
import 'package:ser_manos_mobile/volunteer/presentation/volunteer_map.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';

import '../../providers/service_providers.dart';


class VolunteerScreen extends HookConsumerWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMap = useState(false);
    final volunteerings = ref.watch(volunteeringsNotifierProvider);
    final isLoading = useState(true);


    void toggleMap() {
      showMap.value = !showMap.value;
    }

    useEffect(() {
      if(volunteerings == null) {
        final volunteeringService = ref.read(volunteeringServiceProvider);
        StreamSubscription<Map<String, Volunteering>> subscription = volunteeringService.fetchVolunteerings().listen((volunteerings) {
          Future.microtask(() {
            ref.read(volunteeringsNotifierProvider.notifier).setVolunteerings(volunteerings);
            isLoading.value = false;
          });
        });
        Future.microtask(() {
          ref.read(volunteeringsStreamNotifierProvider.notifier).setStream(subscription);
        });
      } else {
        isLoading.value = false;
      }
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
