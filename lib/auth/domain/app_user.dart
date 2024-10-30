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


  AppUser({
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.birthDate,
    this.gender,
    this.phoneNumber,
    this.profilePictureURL
  });

  bool isComplete (){
    return
      birthDate != null && email.isNotEmpty && gender != null && phoneNumber != null;
  }

  factory AppUser.fromJson(Map<String, dynamic> json) => _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);

  AppUser copyWith({
    String? uid,
    String? firstName,
    String? lastName,
    String? email,
    DateTime? birthDate,
    Gender? gender,
    String? phoneNumber,
    String? profilePictureURL,
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