import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

final FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;

@riverpod
FirebaseAuth firebaseAuth(ref) {
  return firebaseAuthInstance;
}

final FirebaseStorage firebaseStorageInstance = FirebaseStorage.instance;

@riverpod
FirebaseStorage firebaseStorage(ref) {
  return firebaseStorageInstance;
}

final FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;

@riverpod
FirebaseFirestore firebaseFirestore(ref) {
  return firebaseFirestoreInstance;
}