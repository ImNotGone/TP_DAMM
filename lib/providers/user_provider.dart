import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/auth/domain/user.dart';

part 'user_provider.g.dart';

User currentUser = User(
  name: 'Juan',
  lastName: 'Perez',
  email: 'juan@gmail.com',
  password: '123456',
);

@riverpod
User users(ref) {
  return currentUser;
}
