import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'firebase_providers.g.dart';

final FirebaseAuth firebaseAuthInstance = FirebaseAuth.instance;

@Riverpod(keepAlive: true)
FirebaseAuth firebaseAuth(ref) {
  return firebaseAuthInstance;
}

final FirebaseStorage firebaseStorageInstance = FirebaseStorage.instance;

@Riverpod(keepAlive: true)
FirebaseStorage firebaseStorage(ref) {
  return firebaseStorageInstance;
}

final FirebaseFirestore firebaseFirestoreInstance = FirebaseFirestore.instance;

@Riverpod(keepAlive: true)
FirebaseFirestore firebaseFirestore(ref) {
  return firebaseFirestoreInstance;
}