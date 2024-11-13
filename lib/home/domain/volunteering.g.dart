// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteering.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Volunteering _$VolunteeringFromJson(Map<String, dynamic> json) => Volunteering(
      uid: json['uid'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$VolunteeringTypeEnumMap, json['type']),
      purpose: json['purpose'] as String,
      activityDetail: json['activityDetail'] as String,
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      address: json['address'] as String,
      requirements: json['requirements'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      vacancies: (json['vacancies'] as num).toInt(),
    );

const _$VolunteeringTypeEnumMap = {
  VolunteeringType.socialAction: 'socialAction',
};

Location _$LocationFromJson(Map<String, dynamic> json) => Location(
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
