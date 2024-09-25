import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:ser_manos_mobile/home/domain/volunteering.dart';

part 'volunteering_provider.g.dart';

List<Volunteering> allVolunteerings = [
Volunteering(
  imageUrl: 'https://via.placeholder.com/400x200',
  title: 'Un Techo Para mi País',
  type: 'ACCIÓN SOCIAL',
  purpose: '',
  activitiesDetail: '',
  address: '',
  requirements: '',
  creationDate: DateTime.now(),
vacancies: 10
),
Volunteering(
  imageUrl: 'https://via.placeholder.com/400x200',
  title: 'Manos caritativas',
  type: 'ACCIÓN SOCIAL',
  purpose: '',
  activitiesDetail: '',
  address: '',
  requirements: '',
  creationDate: DateTime.now(),
  vacancies: 10
),
Volunteering(
  imageUrl: 'https://via.placeholder.com/400x200',
  title: 'Asociacion Conciencia',
  type: 'ACCIÓN SOCIAL',
  purpose: '',
  activitiesDetail: '',
  address: '',
  requirements: '',
  creationDate: DateTime.now(),
  vacancies: 10
),
];

@riverpod
List<Volunteering> volunteerings(ref) {
  return allVolunteerings;
}