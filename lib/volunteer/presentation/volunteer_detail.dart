import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/auth/application/user_service.dart';
import 'package:ser_manos_mobile/volunteer/application/volunteering_service.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';
import 'package:ser_manos_mobile/shared/cells/cards/location_card.dart';
import 'package:ser_manos_mobile/shared/cells/modals/modal.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/text.dart';
import 'package:ser_manos_mobile/shared/molecules/components/vacancies.dart';
import '../../auth/domain/app_user.dart';
import '../../providers/service_providers.dart';
import '../../shared/molecules/buttons/filled.dart';
import '../../shared/tokens/colors.dart';
import '../domain/volunteering.dart';

class VolunteeringDetail extends HookConsumerWidget {
  final String volunteeringId;

  const VolunteeringDetail({
    super.key,
    required this.volunteeringId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // find the volunteering that has volunteeringId
    final Volunteering? volunteering =
    ref.watch(volunteeringsNotifierProvider)?[volunteeringId];
    final AppUser? currentUser = ref.watch(currentUserNotifierProvider);

    final VolunteeringService volunteeringService = ref.read(volunteeringServiceProvider);
    final UserService userService = ref.read(userServiceProvider);

    Future<void> volunteerToVolunteering() async {
      try {
        Volunteering? updatedVolunteering =
        await volunteeringService.volunteerToVolunteering(volunteeringId, currentUser!.uid);
        if (updatedVolunteering != null) {
          ref
              .read(volunteeringsNotifierProvider.notifier)
              .updateVolunteering(updatedVolunteering);
          AppUser user = await userService.applyToVolunteering(volunteeringId);
          ref.read(currentUserNotifierProvider.notifier).setUser(user);
        }
      } catch (e) {
        log(e.toString());
      }
    }

    Future<void> unvolunteerToVolunteering(String volId) async {
      try {
        Volunteering? updatedVolunteering =
        await volunteeringService.unvolunteerToVolunteering(volId, currentUser!.uid);
        if (updatedVolunteering != null) {
          ref
              .read(volunteeringsNotifierProvider.notifier)
              .updateVolunteering(updatedVolunteering);
          AppUser user = await userService.unapplyToVolunteering();
          ref.read(currentUserNotifierProvider.notifier).setUser(user);
        }
      } catch (e) {
        log(e.toString());
      }
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: SerManosColors.neutral0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.pop();
          },
        ),
      ),
      body: volunteering == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              child: Image.network(
                volunteering.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    volunteering.type
                        .localizedName(context)
                        .toUpperCase(),
                    style: Theme
                        .of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: SerManosColors.neutral75),
                  ),
                  Text(
                    volunteering.title,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    volunteering.purpose,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: SerManosColors.secondary200),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    AppLocalizations.of(context)!.activityDetailsTitle,
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    volunteering.activityDetail,
                    style: Theme
                        .of(context)
                        .textTheme
                        .bodyLarge,
                  ),
                  const SizedBox(height: 24),
                  LocationCard(address: volunteering.address, location: volunteering.location),
                  const SizedBox(height: 24),
                  _buildParticipationInfo(context, volunteering),
                  const SizedBox(height: 24),
                  if (currentUser!.registeredVolunteeringId != null) ...[
                    if(volunteering.applicants[currentUser.uid] != null)...[
                      if (volunteering.applicants[currentUser.uid]!) ...[
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .youreParticipating,
                            style:
                            Theme
                                .of(context)
                                .textTheme
                                .headlineMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!
                              .organizationConfirmation,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        UtilTextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    Modal(
                                      confirmButtonText:
                                      AppLocalizations.of(context)!.confirm,
                                      onConfirm: () {
                                        unvolunteerToVolunteering(
                                            volunteeringId);
                                      },
                                      context: context,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .sureToAbandon,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Text(
                                            volunteering.title,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                              );
                            },
                            text: AppLocalizations.of(context)!
                                .abandonVolunteering),

                      ] else ...[
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .youApplied,
                            style:
                            Theme
                                .of(context)
                                .textTheme
                                .headlineMedium,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppLocalizations.of(context)!
                              .confirmationPending,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        UtilTextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    Modal(
                                      confirmButtonText:
                                      AppLocalizations.of(context)!.confirm,
                                      onConfirm: () {
                                        unvolunteerToVolunteering(
                                            volunteeringId);
                                      },
                                      context: context,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .sureToUnapply,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Text(
                                            volunteering.title,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                              );
                            },
                            text: AppLocalizations.of(context)!
                                .abandonVolunteering),
                      ]
                    ] else
                      if (currentUser.registeredVolunteeringId !=
                          volunteeringId) ...[
                        Center(
                          child: Text(
                            AppLocalizations.of(context)!
                                .alreadyParticipating,
                            style: Theme
                                .of(context)
                                .textTheme
                                .bodyLarge,
                          ),
                        ),
                        const SizedBox(height: 8),
                        UtilTextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    Modal(
                                      confirmButtonText:
                                      AppLocalizations.of(context)!.confirm,
                                      onConfirm: () {
                                        unvolunteerToVolunteering(currentUser
                                            .registeredVolunteeringId!);
                                      },
                                      context: context,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .sureToAbandon,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .titleMedium,
                                          ),
                                          Text(
                                            ref.read(
                                                volunteeringsNotifierProvider)
                                            ![currentUser
                                                .registeredVolunteeringId!]
                                            !.title,
                                            style: Theme
                                                .of(context)
                                                .textTheme
                                                .headlineMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                              );
                            },
                            text: AppLocalizations.of(context)!
                                .abandonVolunteering),
                        const SizedBox(height: 24),
                        UtilFilledButton(
                          onPressed: null,
                          text: AppLocalizations.of(context)!
                              .applyForVolunteering,
                        ),
                      ]
                  ] else if (volunteering.vacancies <= 0) ...[
                      Center(
                        child: Text(
                          AppLocalizations.of(context)!.noVacancies,
                          style: Theme
                              .of(context)
                              .textTheme
                              .bodyLarge,
                        ),
                      ),
                      const SizedBox(height: 24),
                      UtilFilledButton(
                        onPressed: null,
                        text: AppLocalizations.of(context)!
                            .applyForVolunteering,
                      ),
                    ] else if(!currentUser.isComplete()) ...[
                    UtilFilledButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              Modal(
                                confirmButtonText:
                                AppLocalizations.of(context)!.completeData,
                                onConfirm: () {
                                  context.push('/profile_edit', extra: volunteeringId);
                                },
                                context: context,
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .firstCompleteProfile,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                      text: AppLocalizations.of(context)!
                          .applyForVolunteering,
                    ),
                  ] else ...[
                        UtilFilledButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  Modal(
                                    confirmButtonText:
                                    AppLocalizations.of(context)!.confirm,
                                    onConfirm: volunteerToVolunteering,
                                    context: context,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .youAreApplyingTo,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                        Text(
                                          volunteering.title,
                                          style: Theme
                                              .of(context)
                                              .textTheme
                                              .headlineMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                          text: AppLocalizations.of(context)!
                              .applyForVolunteering,
                        ),
                      ],
                  const SizedBox(height: 32),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildParticipationInfo(BuildContext context,
      Volunteering volunteering) {
    final requirementsList = volunteering.requirements.split('  ');
    final formattedRequirements = requirementsList.join('\n');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.participateInVolunteering,
          style: Theme
              .of(context)
              .textTheme
              .headlineMedium,
        ),
        const SizedBox(height: 8),
        MarkdownBody(
          data: formattedRequirements,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          softLineBreak: true,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Vacancies(count: volunteering.vacancies),
          ],
        ),
      ],
    );
  }
}
