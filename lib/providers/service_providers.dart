import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/auth/application/user_service.dart';
import 'package:ser_manos_mobile/auth/data/user_repository.dart';

import 'firebase_providers.dart';

part 'service_providers.g.dart';

@riverpod
UserService userService(ref) {
  FirebaseFirestore firestore = ref.read(firebaseFirestoreProvider);
  FirebaseAuth auth = ref.read(firebaseAuthProvider);
  final UserRepository userRepository = UserRepository(firestore, auth);
  final UserService userServiceInstance = UserService(userRepository);
  return userServiceInstance;
}

