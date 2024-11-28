import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/auth/domain/app_start_state.dart';

part 'app_state_provider.g.dart';


@Riverpod(keepAlive: true)
class AppStateNotifier extends _$AppStateNotifier {
  @override
  AppStartState build() {
    return AppStartState.loading;
  }

  void authenticate() {
    state = AppStartState.authenticated;
  }

  void unauthenticate() {
    state = AppStartState.unauthenticated;
  }
}