import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    this.favouriteVolunteeringIds
  });

  bool isComplete (){
    return
      birthDate != null && email.isNotEmpty && gender != null && phoneNumber != null;
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
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          birthDate == other.birthDate &&
          gender == other.gender &&
          phoneNumber == other.phoneNumber &&
          profilePictureURL == other.profilePictureURL &&
          registeredVolunteeringId == other.registeredVolunteeringId &&
          favouriteVolunteeringIds == other.favouriteVolunteeringIds;

  @override
  int get hashCode =>
      uid.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      birthDate.hashCode ^
      gender.hashCode ^
      phoneNumber.hashCode ^
      profilePictureURL.hashCode ^
      registeredVolunteeringId.hashCode ^
      favouriteVolunteeringIds.hashCode;

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
        return AppLocalizations.of(context)!.male;
      case Gender.female:
        return AppLocalizations.of(context)!.female;
      case Gender.nonBinary:
        return AppLocalizations.of(context)!.nonBinary;
    }
  }
}