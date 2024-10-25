import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/auth/application/auth_service.dart';

part 'auth_service_provider.g.dart';

final AuthService authServiceInstance = AuthService();

@riverpod
AuthService authService(ref) {
  return authServiceInstance;
}

