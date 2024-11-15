import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/auth/application/user_service.dart';
import 'package:ser_manos_mobile/auth/data/user_repository.dart';
import 'package:ser_manos_mobile/volunteer/application/volunteering_service.dart';
import 'package:ser_manos_mobile/volunteer/data/volunteering_repository.dart';

import '../news/application/news_service.dart';
import '../news/data/news_repository.dart';
import 'firebase_providers.dart';

part 'service_providers.g.dart';



@Riverpod(keepAlive: true)
UserService userService(ref) {
  FirebaseFirestore firestore = ref.read(firebaseFirestoreProvider);
  FirebaseAuth auth = ref.read(firebaseAuthProvider);
  FirebaseStorage storage = ref.read(firebaseStorageProvider);
  final UserRepository userRepository = UserRepository(firestore, auth, storage);
  final UserService userServiceInstance = UserService(userRepository);
  return userServiceInstance;
}

@Riverpod(keepAlive: true)
VolunteeringService volunteeringService(ref) {
  FirebaseFirestore firestore = ref.read(firebaseFirestoreProvider);
  VolunteeringRepository volunteeringRepository = VolunteeringRepository(firestore);
  final VolunteeringService volunteeringServiceInstance = VolunteeringService(volunteeringRepository);
  return volunteeringServiceInstance;
}

@Riverpod(keepAlive: true)
NewsService newsService(ref) {
  FirebaseFirestore firestore = ref.read(firebaseFirestoreProvider);
  final NewsRepository newsRepository = NewsRepository(firestore);
  final NewsService newsServiceInstance = NewsService(newsRepository);
  return newsServiceInstance;
}

