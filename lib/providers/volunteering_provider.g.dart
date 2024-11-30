// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'volunteering_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$volunteeringsNotifierHash() =>
    r'523aebacd77684c1750cdbba34a43299ef981f22';

/// See also [VolunteeringsNotifier].
@ProviderFor(VolunteeringsNotifier)
final volunteeringsNotifierProvider = NotifierProvider<VolunteeringsNotifier,
    Map<String, Volunteering>?>.internal(
  VolunteeringsNotifier.new,
  name: r'volunteeringsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$volunteeringsNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VolunteeringsNotifier = Notifier<Map<String, Volunteering>?>;
String _$volunteeringsStreamNotifierHash() =>
    r'f79cb538207dae8af8d9114ecc350740b63e5892';

/// See also [VolunteeringsStreamNotifier].
@ProviderFor(VolunteeringsStreamNotifier)
final volunteeringsStreamNotifierProvider = NotifierProvider<
    VolunteeringsStreamNotifier,
    StreamSubscription<Map<String, Volunteering>>?>.internal(
  VolunteeringsStreamNotifier.new,
  name: r'volunteeringsStreamNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$volunteeringsStreamNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$VolunteeringsStreamNotifier
    = Notifier<StreamSubscription<Map<String, Volunteering>>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
