// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteering.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Volunteering _$VolunteeringFromJson(Map<String, dynamic> json) => Volunteering(
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$VolunteeringTypeEnumMap, json['type']),
      purpose: json['purpose'] as String,
      activitiesDetail: json['activitiesDetail'] as String,
      address: json['address'] as String,
      requirements: json['requirements'] as String,
      creationDate: DateTime.parse(json['creationDate'] as String),
      vacancies: (json['vacancies'] as num).toInt(),
    );

const _$VolunteeringTypeEnumMap = {
  VolunteeringType.socialAction: 'socialAction',
};
