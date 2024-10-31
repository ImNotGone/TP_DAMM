import 'package:ser_manos_mobile/home/data/volunteering_repository.dart';
import '../domain/volunteering.dart';

class VolunteeringService{
  final VolunteeringRepository _volunteeringRepository;

  VolunteeringService(this._volunteeringRepository);

  Future<List<Volunteering>> fetchVolunteerings() async {
    return _volunteeringRepository.fetchVolunteerings();
  }

  // TODO: uncomment this method to upload volunteerings
  // void uploadVolunteerings() {
  //   _volunteeringRepository.uploadVolunteerings();
  // }
}