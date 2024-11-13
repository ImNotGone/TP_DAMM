// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      uid: json['uid'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      email: json['email'] as String,
      birthDate: json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
      gender: $enumDecodeNullable(_$GenderEnumMap, json['gender']),
      phoneNumber: json['phoneNumber'] as String?,
      profilePictureURL: json['profilePictureURL'] as String?,
      registeredVolunteeringId: json['registeredVolunteeringId'] as String?,
      favouriteVolunteeringIds:
          (json['favouriteVolunteeringIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList(),
    );

Map<String, dynamic> _$AppUserToJson(AppUser instance) => <String, dynamic>{
      'uid': instance.uid,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'birthDate': instance.birthDate?.toIso8601String(),
      'gender': _$GenderEnumMap[instance.gender],
      'phoneNumber': instance.phoneNumber,
      'profilePictureURL': instance.profilePictureURL,
      'registeredVolunteeringId': instance.registeredVolunteeringId,
      'favouriteVolunteeringIds': instance.favouriteVolunteeringIds,
    };

const _$GenderEnumMap = {
  Gender.male: 'male',
  Gender.female: 'female',
  Gender.nonBinary: 'nonBinary',
};
