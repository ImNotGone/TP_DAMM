class Volunteering {
  String imageUrl;
  String title;
  String type; // TODO: clase propia?
  String purpose;
  String activitiesDetail;
  // TODO: ubicacion en coordenadas? dos float?
  // Coordenates
  String address;
  // TODO: how can it be markdown??
  String requirements;
  DateTime creationDate;
  int vacancies;

  Volunteering({
    required this.imageUrl,
    required this.title,
    required this.type,
    required this.purpose,
    required this.activitiesDetail,
    required this.address,
    required this.requirements,
    required this.creationDate,
    required this.vacancies
  });
}