
import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/volunteer/domain/volunteering.dart';

part 'volunteering_provider.g.dart';

@Riverpod(keepAlive: true)
class VolunteeringsNotifier extends _$VolunteeringsNotifier {
  @override
  Map<String, Volunteering>? build() {
    return null;
  }

  void setVolunteerings(Map<String, Volunteering> volunteerings) {
    state = volunteerings;
  }

  void clearVolunteerings() {
    state = null;
  }

  void updateVolunteering(Volunteering volunteering) {
    state = {...?state, volunteering.uid: volunteering};
  }
}


@Riverpod(keepAlive: true)
class VolunteeringsStreamNotifier extends _$VolunteeringsStreamNotifier {
  @override
  StreamSubscription<Map<String, Volunteering>>? build() {
    return null;
  }

  void setStream(StreamSubscription<Map<String, Volunteering>> stream) {
    state = stream;
  }

  Future<void> clearStream() async {
    await state?.cancel();
    state = null;
  }
}