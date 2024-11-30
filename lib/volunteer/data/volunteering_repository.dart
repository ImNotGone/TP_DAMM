import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import '../domain/volunteering.dart';

class VolunteeringRepository {
  final FirebaseFirestore _firestore;

  VolunteeringRepository(this._firestore);

  Volunteering? _addUidToVolunteering(DocumentSnapshot volunteeringDoc) {
    if (volunteeringDoc.exists && volunteeringDoc.data() != null) {
      final Map<String, dynamic> data = volunteeringDoc.data() as Map<String, dynamic>;
      data['uid'] = volunteeringDoc.id;
      return Volunteering.fromJson(data);
    }
    return null;
  }

  Stream<Map<String, Volunteering>> fetchVolunteerings() {
    return _firestore.collection('volunteerings').snapshots().map((snapshot) {
      HashMap<String, Volunteering> volunteerings = HashMap();
      for (var volunteeringDoc in snapshot.docs) {
        volunteerings[volunteeringDoc.id] = _addUidToVolunteering(volunteeringDoc)!;
      }
      return volunteerings;
    });
  }

  // New volunteer to volunteering -> vacancies - 1 in transaction to avoid race condition
  // Check if vacancies is <= 0. If so, fail
  Future<Volunteering?> volunteerToVolunteering(String volunteeringId, String userId) async {
    final volunteeringRef =
        _firestore.collection('volunteerings').doc(volunteeringId);

    return await _firestore.runTransaction((transaction) async {
      final volunteeringDoc = await transaction.get(volunteeringRef);
      final volunteering = _addUidToVolunteering(volunteeringDoc)!;
      if (volunteering.vacancies <= 0) {
        throw Exception('No vacancies left');
      }
      transaction.update(volunteeringRef, {'applicants.$userId': false});
      return volunteering;
    }).then(
      (value) async {
        final updatedDoc = await volunteeringRef.get();
        return _addUidToVolunteering(updatedDoc);
      },
      onError: (e) => throw Exception('Error updating Volunteering $e'),
    );
  }

  // Volunteer gets out of volunteering
  Future<Volunteering?> unvolunteerToVolunteering(String volunteeringId, String userId) async {
    final volunteeringRef =
        _firestore.collection('volunteerings').doc(volunteeringId);

    return await _firestore.runTransaction((transaction) async {
      final volunteeringDoc = await transaction.get(volunteeringRef);
      final volunteering = _addUidToVolunteering(volunteeringDoc)!;

      transaction.update(volunteeringRef, {'applicants.$userId': FieldValue.delete()});

      // If the user was a confirmed applicant, increase vacancies
      if(volunteering.applicants[userId]!) {
        transaction.update(volunteeringRef, {'vacancies': volunteering.vacancies + 1});
        volunteering.vacancies += 1;
      }

      volunteering.applicants.remove(userId);
      
      return volunteering;
    }).then(
      (value) async {
        final updatedDoc = await volunteeringRef.get();
        return _addUidToVolunteering(updatedDoc);
      },
      onError: (e) => throw Exception('Error updating Volunteering $e'),
    );
  }
}
