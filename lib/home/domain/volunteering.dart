import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

part 'volunteering.g.dart';

@JsonSerializable(createToJson: false)
class Volunteering {
  String uid;
  String imageUrl;
  String title;
  VolunteeringType type;
  String purpose;
  String activityDetail;

  // Local to current user
  @JsonKey(includeFromJson: false, includeToJson: false)
  bool isFavourite;

  // GeoPoint is not JsonSerializable so we need to provide custom serialization
  @JsonKey(fromJson: _fromJsonGeoPoint, toJson: _toJsonGeoPoint)
  GeoPoint location;
  String address;

  String requirements;
  DateTime creationDate;
  int vacancies;

  Map<String, bool> applicants;

  Volunteering(
      {required this.uid,
      required this.imageUrl,
      required this.title,
      required this.type,
      required this.purpose,
      required this.activityDetail,
      required this.location,
      required this.address,
      required this.requirements,
      required this.creationDate,
      required this.vacancies,
      this.applicants = const {},
      this.isFavourite = false});

  factory Volunteering.fromJson(Map<String, dynamic> json) =>
      _$VolunteeringFromJson(json);

// Map<String, dynamic> toJson() => _$VolunteeringToJson(this);

  Volunteering copyWith({
    String? uid,
    String? imageUrl,
    String? title,
    VolunteeringType? type,
    String? purpose,
    String? activityDetail,
    GeoPoint? location,
    String? address,
    String? requirements,
    DateTime? creationDate,
    int? vacancies,
    bool? isFavourite,
    Map<String, bool>? applicants,
  }) {
    return Volunteering(
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      type: type ?? this.type,
      purpose: purpose ?? this.purpose,
      activityDetail: activityDetail ?? this.activityDetail,
      location: location ?? this.location,
      address: address ?? this.address,
      requirements: requirements ?? this.requirements,
      creationDate: creationDate ?? this.creationDate,
      vacancies: vacancies ?? this.vacancies,
      isFavourite: isFavourite ?? this.isFavourite,
      applicants: applicants ?? this.applicants,
    );
  }


  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Volunteering &&
          uid == other.uid;

  @override
  int get hashCode =>
      uid.hashCode;

  @override
  String toString() {
    return 'Volunteering{uid: $uid, imageUrl: $imageUrl, title: $title, type: $type, purpose: $purpose, activityDetail: $activityDetail, isFavourite: $isFavourite, location: $location, address: $address, requirements: $requirements, creationDate: $creationDate, vacancies: $vacancies}';
  }

  static GeoPoint _fromJsonGeoPoint(GeoPoint geoPoint) {
    return geoPoint;
  }

  static GeoPoint _toJsonGeoPoint(GeoPoint geoPoint) {
    return geoPoint;
  }
}

enum VolunteeringType {
  socialAction;

  String localizedName(BuildContext context) {
    switch (this) {
      case VolunteeringType.socialAction:
        return AppLocalizations.of(context)!.socialAction;
    }
  }
}