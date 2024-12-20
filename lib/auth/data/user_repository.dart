import 'dart:developer';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:ser_manos_mobile/auth/domain/app_user.dart';

class UserRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;

  UserRepository(this._firestore, this._auth, this._storage);

  Future<AppUser> createUser(
      User user, String firstName, String lastName, String fcmToken) async {
    final newUser = AppUser(
      uid: user.uid,
      email: user.email!,
      firstName: firstName,
      lastName: lastName,
      fcmToken: fcmToken,
    );
    await _firestore.collection('users').doc(user.uid).set(newUser.toJson());
    return newUser;
  }

  Future<AppUser> fetchUser(String uid) async {
    final userJson = await _firestore.collection('users').doc(uid).get();

    if (userJson.data() == null || userJson.data()!.isEmpty) {
      throw Exception('User not found');
    }

    final data = userJson.data();
    data?['uid'] = uid;
    AppUser user = AppUser.fromJson(data!);
    return user;
  }

  Future<AppUser> fetchCurrentUser() async {
    if (!isLoggedIn) {
      throw Exception('User not found');
    }
    return fetchUser(_auth.currentUser!.uid);
  }

  Future<AppUser> updateUser(AppUser user) async {
    await _firestore.collection('users').doc(user.uid).update(user.toJson());
    return user;
  }

  Future<String?> uploadProfilePicture(File imageFile) async {
    try {
      if (!isLoggedIn) {
        log('No authenticated user found.');
        return null;
      }
      String userId = _auth.currentUser!.uid;

      // Create a storage reference
      Reference storageRef = _storage.ref().child('profile_pictures/$userId');

      // Upload the file to Firebase Storage
      UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      final photoURL = await snapshot.ref.getDownloadURL();

      // Update Firebase Auth profile photo URL
      await _auth.currentUser?.updatePhotoURL(photoURL);

      // Update Firestore user document with the profile picture URL
      await _firestore.collection('users').doc(userId).update({
        'profilePictureURL': photoURL,
      });
      return photoURL;
    } catch (e) {
      log('Error uploading profile picture: $e');
    }
    return null;
  }

  Future<User?> signUp(String email, String password) async {
    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential.user;
  }

  Future<User?> signIn(String email, String password) async {
    final credential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return credential.user;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  bool get isLoggedIn => _auth.currentUser != null;
}
