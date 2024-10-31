import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/home/domain/volunteering.dart';

part 'volunteering_provider.g.dart';

@Riverpod(keepAlive: true)
class VolunteeringsNotifier extends _$VolunteeringsNotifier {
  @override
  List<Volunteering>? build() {
    return null;
  }

  void setVolunteerings(List<Volunteering> volunteerings) {
    state = volunteerings;
  }

  void clearVolunteerings() {
    state = null;
  }
}