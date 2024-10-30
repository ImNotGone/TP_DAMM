import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

import '../data/user_repository.dart';
import '../domain/app_user.dart';

class UserService{
  final UserRepository _userRepository;

  UserService(this._userRepository);

  Future<User?> signIn(String email, String password) async {
    return await _userRepository.signIn(email, password);
  }

  Future<void> signUp(String firstName, String lastName, String email, String password) async {
    try {
      User? user = await _userRepository.signUp(email, password);
      if (user != null) {
        await _userRepository.createUser(user, firstName, lastName);
      }
    }
    catch (e) {
      log(e.toString());
    }
  }

  Future<void> signOut() {
    return _userRepository.signOut();
  }

  bool isLoggedIn() {
    return _userRepository.isLoggedIn;
  }

  Future<AppUser?> getCurrentUser() {
    return _userRepository.fetchCurrentUser();
  }

  Future<AppUser> updateUser(AppUser user) async {
    return await _userRepository.updateUser(user);
  }

  Future<String?> uploadProfilePicture(File imageFile) async {
    return await _userRepository.uploadProfilePicture(imageFile);
  }
}