import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:ser_manos_mobile/auth/domain/app_user.dart';
import 'package:ser_manos_mobile/auth/data/user_repository.dart';
import 'package:ser_manos_mobile/auth/application/user_service.dart';
import 'user_test.mocks.dart';

@GenerateMocks([UserRepository, AppUser, User])
void main() {
  late MockUserRepository mockUserRepository;
  late UserService userService;

  setUp(() {
    mockUserRepository = MockUserRepository();
    userService = UserService(mockUserRepository);
  });

  group('signIn', () {
    test('should call signIn on UserRepository with correct parameters', () async {
      final email = 'test@example.com';
      final password = 'password123';
      final mockUser = MockUser();

      when(mockUserRepository.signIn(email, password)).thenAnswer((_) async => mockUser);

      final result = await userService.signIn(email, password);

      verify(mockUserRepository.signIn(email, password)).called(1);
      expect(result, mockUser);
    }, tags: ['user']);
  });

  group('signUp', () {
    test('should call signUp and createUser on UserRepository when a user is signed up', () async {
      // Arrange
      final email = 'test@example.com';
      final password = 'password123';
      final firstName = 'John';
      final lastName = 'Doe';
      final fcmToken = 'fcmToken';
      final mockUser = MockUser();
      final appUser = AppUser(
        uid: '123',
        email: email,
        firstName: firstName,
        lastName: lastName,
      );

      when(mockUserRepository.signUp(email, password)).thenAnswer((_) async => mockUser);

      when(mockUserRepository.createUser(mockUser, firstName, lastName, fcmToken)).thenAnswer((_) async => appUser);

      await userService.signUp(firstName, lastName, email, password, fcmToken);

      verify(mockUserRepository.signUp(email, password)).called(1);
      verify(mockUserRepository.createUser(mockUser, firstName, lastName, fcmToken)).called(1);
    }, tags: ['user']);
  });

  group('signOut', () {
    test('should call signOut on UserRepository', () async {
      when(mockUserRepository.signOut()).thenAnswer((_) async {});

      await userService.signOut();

      verify(mockUserRepository.signOut()).called(1);
    });
  });

  group('isLoggedIn', () {
    test('should return the logged-in status from UserRepository', () {
      when(mockUserRepository.isLoggedIn).thenReturn(true);

      final result = userService.isLoggedIn();

      verify(mockUserRepository.isLoggedIn).called(1);
      expect(result, true);
    }, tags: ['user']);
  });

  group('getCurrentUser', () {
    test('should return the current user fetched from UserRepository', () async {
      final mockAppUser = AppUser(uid: '123', email: 'test@example.com', firstName: 'pepe', lastName: 'pepina');

      when(mockUserRepository.fetchCurrentUser()).thenAnswer((_) async => mockAppUser);

      final result = await userService.getCurrentUser();

      verify(mockUserRepository.fetchCurrentUser()).called(1);
      expect(result, mockAppUser);
    }, tags: ['user']);
  });

  group('uploadProfilePicture', () {
    test('should call uploadProfilePicture on UserRepository with the correct file', () async {
      final mockFile = File('path/to/file');
      final mockUrl = 'https://example.com/profile.jpg';

      when(mockUserRepository.uploadProfilePicture(mockFile)).thenAnswer((_) async => mockUrl);

      final result = await userService.uploadProfilePicture(mockFile);

      verify(mockUserRepository.uploadProfilePicture(mockFile)).called(1);
      expect(result, mockUrl);
    }, tags: ['user']);
  });

  group('volunteering operations', () {
    test('should add volunteering ID to user\'s favorites', () async {
      final volunteeringId = 'vol123';
      final mockAppUser = AppUser(uid: '123', firstName: 'pepe', lastName: 'pepina', email: 'test@example.com', favouriteVolunteeringIds: []);

      when(mockUserRepository.fetchCurrentUser()).thenAnswer((_) async => mockAppUser);
      when(mockUserRepository.updateUser(mockAppUser)).thenAnswer((_) async => mockAppUser);

      final result = await userService.markVolunteeringAsFavourite(volunteeringId);

      expect(result.favouriteVolunteeringIds, contains(volunteeringId));
      verify(mockUserRepository.updateUser(mockAppUser)).called(1);
    }, tags: ['user']);

    test('should remove volunteering ID from user\'s favorites', () async {
      final volunteeringId = 'vol123';
      final mockAppUser = AppUser(uid: '123', email: 'test@example.com',firstName: 'pepe', lastName: 'pepina', favouriteVolunteeringIds: [volunteeringId]);

      when(mockUserRepository.fetchCurrentUser()).thenAnswer((_) async => mockAppUser);
      when(mockUserRepository.updateUser(mockAppUser)).thenAnswer((_) async => mockAppUser);

      final result = await userService.unmarkVolunteeringAsFavourite(volunteeringId);

      expect(result.favouriteVolunteeringIds, isNot(contains(volunteeringId)));
      verify(mockUserRepository.updateUser(mockAppUser)).called(1);
    }, tags: ['user']);
  });
}
