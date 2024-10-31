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

  // TODO: ubicacion en coordenadas? dos float?
  // Coordenates
  String address;

  // TODO: how can it be markdown??
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
      required this.vacancies});

  factory Volunteering.fromJson(Map<String, dynamic> json) =>
      _$VolunteeringFromJson(json);

// Map<String, dynamic> toJson() => _$VolunteeringToJson(this);
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
