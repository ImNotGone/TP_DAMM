import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'is_logged_in_provider.g.dart';


@Riverpod(keepAlive: true)
class IsLoggedInNotifier extends _$IsLoggedInNotifier {
  @override
  bool build() {
    return false;
  }

  void logIn() {
    state = true;
  }

  void logOut() {
    state = false;
  }
}