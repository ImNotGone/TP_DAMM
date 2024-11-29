import 'package:ser_manos_mobile/volunteer/data/volunteering_repository.dart';
import '../domain/volunteering.dart';

class VolunteeringService{
  final VolunteeringRepository _volunteeringRepository;

  VolunteeringService(this._volunteeringRepository);

  Stream<Map<String, Volunteering>> fetchVolunteerings() {
    return _volunteeringRepository.fetchVolunteerings();
  }

  Future<Volunteering?> volunteerToVolunteering(String volunteeringId, String userId)  async {
    return await _volunteeringRepository.volunteerToVolunteering(volunteeringId, userId);
  }

  Future<Volunteering?> unvolunteerToVolunteering(String volunteeringId, String userId) async {
    return await _volunteeringRepository.unvolunteerToVolunteering(volunteeringId, userId);
  }

  // TODO: uncomment this method to upload volunteerings
  // void uploadVolunteerings() {
  //   _volunteeringRepository.uploadVolunteerings();
  // }
}