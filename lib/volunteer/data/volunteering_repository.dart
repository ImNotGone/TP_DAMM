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

// TODO: uncomment this method to upload volunteerings
// List<Volunteering> allVolunteerings = [
//   Volunteering(
//       imageUrl: 'https://s3-alpha-sig.figma.com/img/6160/48a8/56fafc1f797d16aeaaa7f76477bdc239?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=ls0WT-fenPWC44APkCU24Q-hbfeO1SAxkQkQnMFZgjj4M7l5SXGvlNsfJDRLCDwncFl3j9a89etOFuGCilw7XwEsxVacJ4KSIkUr8t-uj~cs~Xu7WtVhbMOYIhz0Wo43r2hKNn7L6WHLsoRtmi~DEQoJPndzLZtHlq7a4JuXwvNP2s16UodMe7ro0wd7r-rgTXMqlCfJoAKyqKI9i3TnCtirVLmuW7DmsYATk4cyn4I0MNh9VeClS14H89cW6jeYekTtHG9MxP~GkEVWs0iAhLZK0osUwmr7tn8IFvKCudvphtiag-3zARahG1FWIdoInZLA0r9iVHySYymZhHaKkw__',
//       title: 'Un Techo Para mi País',
//       type: VolunteeringType.socialAction,
//       purpose: 'El propósito principal de "Un techo para mi país" es reducir el déficit habitacional y mejorar las condiciones de vida de las personas que no tienen acceso a una vivienda adecuada.',
//       activityDetail: 'Te necesitamos para construir las viviendas de las personas que necesitan un techo. Estas están prefabricadas en madera y deberás ayudar en carpintería, montaje, pintura y demás actividades de la construcción.',
//       address: 'Echeverría 3560, Capital Federal',
//       requirements: '### **Requisitos** - **Mayor de edad.** - **Poder levantar cosas pesadas.**  ### **Disponibilidad** - **Martes:** 10h a 12h - **Jueves:** 10h a 12h',
//       creationDate: DateTime.now(),
//       vacancies: 10
//   ),
//   Volunteering(
//       imageUrl: 'https://s3-alpha-sig.figma.com/img/8bbc/83c6/6d6e4bcbf3c909838293a3128e40c314?Expires=1731283200&Key-Pair-Id=APKAQ4GOSFWCVNEHN3O4&Signature=QnGKTL7RH8ehzAiu4FyrvIQP7FBWZG-lX8cqUVMr2k~-3EGS2RVxFfvCazIv43jXsCg13HYawfc5CFmhI4W4H8oKH2bq88b7Y9zuAN~anABsJ~FfniPNEtIwfGoYY8W9hHTkycwL8DKDl1XTFYAlsnxwrTBNJWLHzUK3zmKSDEbjEmv6b601WsizC1xAbC0Kzsh74Pvqh8FGQZnGbka8-mJD3ObHn4U4grD6bJmKLmom9~hm05DGmsYL2AaKVbuQDRpPRd14c1f7K9YUhC7LYXGZgJAqWy-mr9xLaQh3wut9TEANh5UbmkslYOcju1uQpx1QFV6fQgoQe-RQyoXjrQ__',
//       title: 'Manos caritativas',
//       type: VolunteeringType.socialAction,
//       purpose: 'El propósito principal de "Manos caritativas" es...',
//       activityDetail: 'Contribuir a la alimentación de las personas en situación de calle.',
//       address: 'Av. Las Heras 1234, Capital Federal',
//       requirements: '### **Requisitos** - **Mayor de edad.** - **Ser solidario.**  ### **Disponibilidad** - **Lunes:** 11h a 12h',
//       creationDate: DateTime.now(),
//       vacancies: 10
//   ),
// ];
//
// void uploadVolunteerings() {
//   for (var volunteering in allVolunteerings) {
//     _firestore.collection('volunteerings').add(volunteering.toJson());
//   }
// }
}
