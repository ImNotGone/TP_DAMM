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

  // TODO: ubicacion en coordenadas? dos float?
  // Coordenates
  String address;

  String requirements;
  DateTime creationDate;
  int vacancies;

  Volunteering(
      {required this.uid,
      required this.imageUrl,
      required this.title,
      required this.type,
      required this.purpose,
      required this.activityDetail,
      required this.address,
      required this.requirements,
      required this.creationDate,
      required this.vacancies,
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
    String? address,
    String? requirements,
    DateTime? creationDate,
    int? vacancies,
    bool? isFavourite,
  }) {
    return Volunteering(
      uid: uid ?? this.uid,
      imageUrl: imageUrl ?? this.imageUrl,
      title: title ?? this.title,
      type: type ?? this.type,
      purpose: purpose ?? this.purpose,
      activityDetail: activityDetail ?? this.activityDetail,
      address: address ?? this.address,
      requirements: requirements ?? this.requirements,
      creationDate: creationDate ?? this.creationDate,
      vacancies: vacancies ?? this.vacancies,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Volunteering &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          imageUrl == other.imageUrl &&
          title == other.title &&
          type == other.type &&
          purpose == other.purpose &&
          activityDetail == other.activityDetail &&
          isFavourite == other.isFavourite &&
          address == other.address &&
          requirements == other.requirements &&
          creationDate == other.creationDate &&
          vacancies == other.vacancies;

  @override
  int get hashCode =>
      uid.hashCode ^
      imageUrl.hashCode ^
      title.hashCode ^
      type.hashCode ^
      purpose.hashCode ^
      activityDetail.hashCode ^
      isFavourite.hashCode ^
      address.hashCode ^
      requirements.hashCode ^
      creationDate.hashCode ^
      vacancies.hashCode;

  @override
  String toString() {
    return 'Volunteering{uid: $uid, imageUrl: $imageUrl, title: $title, type: $type, purpose: $purpose, activityDetail: $activityDetail, isFavourite: $isFavourite, address: $address, requirements: $requirements, creationDate: $creationDate, vacancies: $vacancies}';
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
