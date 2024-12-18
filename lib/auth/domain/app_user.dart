import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../translations/locale_keys.g.dart';

part 'app_user.g.dart';

@JsonSerializable()
class AppUser {

  String uid;
  String firstName;
  String lastName;
  String email;
  DateTime? birthDate;
  Gender? gender;
  String? phoneNumber;
  String? profilePictureURL;
  String? registeredVolunteeringId;
  List<String>? favouriteVolunteeringIds;
  String? fcmToken;


  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.birthDate,
    this.gender,
    this.phoneNumber,
    this.profilePictureURL,
    this.registeredVolunteeringId,
    this.favouriteVolunteeringIds,
    this.fcmToken
  });

  bool isComplete (){
    return
      birthDate != null && email.isNotEmpty && gender != null && phoneNumber != null && profilePictureURL != null;
  }

  bool isVolunteer(){
    return registeredVolunteeringId != null;
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);


  @override
  String toString() {
    return 'AppUser{uid: $uid, firstName: $firstName, lastName: $lastName, email: $email, birthDate: $birthDate, gender: $gender, phoneNumber: $phoneNumber, profilePictureURL: $profilePictureURL, registeredVolunteeringId: $registeredVolunteeringId, favouriteVolunteeringIds: $favouriteVolunteeringIds}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppUser &&
          uid == other.uid;

  @override
  int get hashCode =>
      uid.hashCode;

  AppUser copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? birthDate,
    Gender? gender,
    String? phoneNumber,
    String? profilePictureURL,
    String? registeredVolunteeringId,
    List<String>? favouriteVolunteeringIds,
    String? fcmToken
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profilePictureURL: profilePictureURL ?? this.profilePictureURL,
      registeredVolunteeringId: registeredVolunteeringId ?? this.registeredVolunteeringId,
      favouriteVolunteeringIds: favouriteVolunteeringIds ?? this.favouriteVolunteeringIds,
      fcmToken: fcmToken ?? this.fcmToken
    );
  }

}

enum Gender{
  male,
  female,
  nonBinary;

  String localizedName(BuildContext context) {
    switch (this) {
      case Gender.male:
        return LocaleKeys.genderMale.tr();
      case Gender.female:
        return LocaleKeys.genderFemale.tr();
      case Gender.nonBinary:
        return LocaleKeys.nonBinary.tr();
    }
  }
}