import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../auth/domain/app_user.dart';

part 'user_provider.g.dart';


@riverpod
class CurrentUserNotifier extends _$CurrentUserNotifier {
  @override
  AppUser? build() {
    return null;
  }

  void setUser(AppUser? user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}