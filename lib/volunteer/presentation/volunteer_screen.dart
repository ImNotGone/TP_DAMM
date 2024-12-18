import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/volunteer/presentation/volunteer_list.dart';
import 'package:ser_manos_mobile/volunteer/presentation/volunteer_map.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';


class VolunteerScreen extends HookConsumerWidget {
  const VolunteerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final showMap = useState(false);
    final volunteerings = ref.watch(volunteeringsNotifierProvider);

    void toggleMap() {
      showMap.value = !showMap.value;
    }

    return (volunteerings.isLoading || volunteerings.isRefreshing || !volunteerings.hasValue)
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
