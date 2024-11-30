import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ser_manos_mobile/volunteer/application/volunteering_service.dart';
import 'package:ser_manos_mobile/volunteer/data/volunteering_repository.dart';
import 'package:ser_manos_mobile/volunteer/domain/volunteering.dart';

import 'volunteering_test.mocks.dart';

@GenerateMocks([VolunteeringRepository])
void main() {
  late MockVolunteeringRepository mockVolunteeringRepository;
  late VolunteeringService volunteeringService;

  setUp(() {
    mockVolunteeringRepository = MockVolunteeringRepository();
    volunteeringService = VolunteeringService(mockVolunteeringRepository);
  });

  group('VolunteeringService', () {
    final volunteering = Volunteering(
      uid: 'v1',
      imageUrl: 'https://example.com/image.png',
      title: 'Beach Cleanup',
      type: VolunteeringType.socialAction,
      purpose: 'Clean beaches for a better environment',
      activityDetail: 'Help pick up trash and recyclables',
      location: GeoPoint(10.0, 20.0),
      address: 'Sunny Beach',
      requirements: 'Bring gloves and bags',
      creationDate: DateTime.now(),
      vacancies: 10,
    );

    test('fetchVolunteerings should call fetchVolunteerings on repository', () async {

      final volunteeringsStream = Stream.value({'v1': volunteering});
      when(mockVolunteeringRepository.fetchVolunteerings())
          .thenAnswer((_) => volunteeringsStream);

      final result = volunteeringService.fetchVolunteerings();

      expect(result, emits({'v1': volunteering}));
      verify(mockVolunteeringRepository.fetchVolunteerings()).called(1);
    });

    test('volunteerToVolunteering should call volunteerToVolunteering on repository', () async {

      final volunteeringId = 'v1';
      final userId = 'u1';
      when(mockVolunteeringRepository.volunteerToVolunteering(volunteeringId, userId))
          .thenAnswer((_) async => volunteering);

      final result = await volunteeringService.volunteerToVolunteering(volunteeringId, userId);

      expect(result, volunteering);
      verify(mockVolunteeringRepository.volunteerToVolunteering(volunteeringId, userId)).called(1);
    });

    test('unvolunteerToVolunteering should call unvolunteerToVolunteering on repository', () async {

      final volunteeringId = 'v1';
      final userId = 'u1';
      when(mockVolunteeringRepository.unvolunteerToVolunteering(volunteeringId, userId))
          .thenAnswer((_) async => volunteering);

      final result = await volunteeringService.unvolunteerToVolunteering(volunteeringId, userId);

      expect(result, volunteering);
      verify(mockVolunteeringRepository.unvolunteerToVolunteering(volunteeringId, userId)).called(1);
    });
  });
}