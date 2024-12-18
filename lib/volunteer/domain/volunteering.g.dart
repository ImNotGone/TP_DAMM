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
      location: Volunteering._fromJsonGeoPoint(json['location'] as GeoPoint),
      address: json['address'] as String,
      requirements: json['requirements'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      vacancies: (json['vacancies'] as num).toInt(),
      applicants: (json['applicants'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      cost: json['cost'] as num,
    );

const _$VolunteeringTypeEnumMap = {
  VolunteeringType.socialAction: 'socialAction',
};
