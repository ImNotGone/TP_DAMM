import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/volunteering.dart';

class VolunteeringRepository{
  final FirebaseFirestore _firestore;

  VolunteeringRepository(this._firestore);

  Future<List<Volunteering>> fetchVolunteering() async {
    final volunteeringJson = await _firestore.collection('volunteering').get();
    List<Volunteering> volunteering = [];
    for (var volunteeringDoc in volunteeringJson.docs) {
      volunteering.add(Volunteering.fromJson(volunteeringDoc.data()));
    }
    return volunteering;
  }
}