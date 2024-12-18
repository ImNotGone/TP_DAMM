import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/volunteer/domain/volunteering.dart';

part 'volunteering_provider.g.dart';

@Riverpod(keepAlive: true)
class VolunteeringsNotifier extends _$VolunteeringsNotifier {
  late StreamSubscription<Map<String, Volunteering>> _subscription;

  @override
  Future<Map<String, Volunteering>?> build() async {
    state = const AsyncLoading();

    ref.onDispose(_dispose);

    final volunteeringService = ref.read(volunteeringServiceProvider);
    _subscription = volunteeringService.fetchVolunteerings().listen(
      (volunteerings) {
        state = AsyncValue.data(volunteerings);
      },
      onError: (error, stackTrace) {
        state = AsyncValue.error(error, stackTrace);
      },
    );

    return null;
  }

  void setVolunteerings(Map<String, Volunteering> volunteerings) {
    state = AsyncValue.data(volunteerings);
  }

  void clearVolunteerings() {
    state = const AsyncValue.data(null);
  }

  void updateVolunteering(Volunteering volunteering) {
    state = AsyncValue.data({...?state.value, volunteering.uid: volunteering});
  }

  void _dispose() async {
    await _subscription.cancel();
  }
}
