
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/volunteer/domain/volunteering.dart';

part 'volunteering_provider.g.dart';

@Riverpod(keepAlive: true)
class VolunteeringsNotifier extends _$VolunteeringsNotifier {
  @override
  Map<String, Volunteering>? build() {
    return {};
  }

  void setVolunteerings(Map<String, Volunteering> volunteerings) {
    state = volunteerings;
  }

  void clearVolunteerings() {
    state = {};
  }

  void updateVolunteering(Volunteering volunteering) {
    state = {...?state, volunteering.uid: volunteering};
  }
}