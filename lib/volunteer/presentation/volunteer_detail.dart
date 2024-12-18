import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ser_manos_mobile/auth/application/user_service.dart';
import 'package:ser_manos_mobile/translations/locale_keys.g.dart';
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
import '../../shared/tokens/text_style.dart';
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
    final Volunteering? volunteering = ref.watch(volunteeringsNotifierProvider).value?[volunteeringId];
    final AppUser? currentUser = ref.watch(currentUserNotifierProvider);

    final VolunteeringService volunteeringService = ref.read(volunteeringServiceProvider);
    final UserService userService = ref.read(userServiceProvider);

    final isLoading = useState(false);

    Future<void> volunteerToVolunteering() async {
      isLoading.value = true;
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
      isLoading.value = false;
    }

    Future<void> unvolunteerToVolunteering(String volId) async {
      isLoading.value = true;
      try {
        Volunteering? updatedVolunteering =
        await volunteeringService.unvolunteerToVolunteering(volId, currentUser!.uid);
        if (updatedVolunteering != null) {
          ref.read(volunteeringsNotifierProvider.notifier).updateVolunteering(updatedVolunteering);
          AppUser user = await userService.unapplyToVolunteering();
          ref.read(currentUserNotifierProvider.notifier).setUser(user);
        }
      } catch (e) {
        log(e.toString());
      }
      isLoading.value = false;
    }

    return Scaffold(
      backgroundColor: SerManosColors.neutral0,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: SerManosColors.neutral0,
          onPressed: () => context.go('/home'),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.transparent,
              ],
            ),
          ),
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
                        style: SerManosTextStyle.overline(),
                      ),
                      Text(
                        volunteering.title,
                        style: SerManosTextStyle.headline01(),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        volunteering.purpose,
                        style: SerManosTextStyle.body01().copyWith(color: SerManosColors.secondary200),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        LocaleKeys.activityDetailsTitle.tr(),
                        style: SerManosTextStyle.headline02(),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        volunteering.activityDetail,
                        style: SerManosTextStyle.body01(),
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
                                LocaleKeys.youreParticipating.tr(),
                                style: SerManosTextStyle.headline02(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              LocaleKeys.organizationConfirmation.tr(),
                              style: SerManosTextStyle.body01(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            UtilTextButton(
                                isLoading: isLoading.value,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        Modal(
                                          confirmButtonText:
                                          LocaleKeys.confirm.tr(),
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
                                                LocaleKeys.sureToAbandon.tr(),
                                                style: SerManosTextStyle.subtitle01(),
                                              ),
                                              Text(
                                                volunteering.title,
                                                style: SerManosTextStyle.headline02(),
                                              ),
                                            ],
                                          ),
                                        ),
                                  );
                                },
                                text: LocaleKeys.abandonVolunteering.tr()),

                          ] else ...[
                            Center(
                              child: Text(
                                  LocaleKeys.youApplied.tr(),
                                style: SerManosTextStyle.headline02()
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              LocaleKeys.confirmationPending.tr(),
                              style: SerManosTextStyle.body01(),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            UtilTextButton(
                                isLoading: isLoading.value,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        Modal(
                                          confirmButtonText:
                                          LocaleKeys.confirm.tr(),
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
                                                LocaleKeys.sureToUnapply.tr(),
                                                style: SerManosTextStyle.subtitle01(),
                                              ),
                                              Text(
                                                volunteering.title,
                                                style: SerManosTextStyle.headline02(),
                                              ),
                                            ],
                                          ),
                                        ),
                                  );
                                },
                                text: LocaleKeys.abandonVolunteering.tr()),
                          ]
                        ] else
                          if (currentUser.registeredVolunteeringId !=
                              volunteeringId) ...[
                            Center(
                              child: Text(
                                LocaleKeys.alreadyParticipating.tr(),
                                style: SerManosTextStyle.body01(),
                              ),
                            ),
                            const SizedBox(height: 8),
                            UtilTextButton(
                                isLoading: isLoading.value,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        Modal(
                                          confirmButtonText:
                                          LocaleKeys.confirm.tr(),
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
                                                LocaleKeys.sureToAbandon.tr(),
                                                style: SerManosTextStyle.subtitle01(),
                                              ),
                                              Text(
                                                ref.read(
                                                    volunteeringsNotifierProvider).value
                                                ![currentUser
                                                    .registeredVolunteeringId!]
                                                !.title,
                                                style: SerManosTextStyle.headline02(),
                                              ),
                                            ],
                                          ),
                                        ),
                                  );
                                },
                                text: LocaleKeys.abandonVolunteering.tr()),
                            const SizedBox(height: 24),
                            UtilFilledButton(
                              onPressed: null,
                              text: LocaleKeys.applyForVolunteering.tr(),
                            ),
                          ]
                      ] else if (volunteering.vacancies <= 0) ...[
                          Center(
                            child: Text(
                              LocaleKeys.noVacancies.tr(),
                              style: SerManosTextStyle.body01(),
                            ),
                          ),
                          const SizedBox(height: 24),
                          UtilFilledButton(
                            onPressed: null,
                            text: LocaleKeys.applyForVolunteering.tr(),
                          ),
                        ] else if(!currentUser.isComplete()) ...[
                        UtilFilledButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  Modal(
                                    confirmButtonText:
                                    LocaleKeys.completeData.tr(),
                                    onConfirm: () {
                                      context.push('/profile_edit', extra: volunteeringId);
                                    },
                                    context: context,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          LocaleKeys.firstCompleteProfile.tr(),
                                          style: SerManosTextStyle.subtitle01(),
                                        ),
                                      ],
                                    ),
                                  ),
                            );
                          },
                          text: LocaleKeys.applyForVolunteering.tr(),
                        ),
                      ] else ...[
                            UtilFilledButton(
                              isLoading: isLoading.value,
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      Modal(
                                        confirmButtonText:
                                        LocaleKeys.confirm.tr(),
                                        onConfirm: volunteerToVolunteering,
                                        context: context,
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              LocaleKeys.youAreApplyingTo.tr(),
                                              style: SerManosTextStyle.subtitle01(),
                                            ),
                                            Text(
                                              volunteering.title,
                                              style: SerManosTextStyle.headline02(),
                                            ),
                                          ],
                                        ),
                                      ),
                                );
                              },
                              text: LocaleKeys.applyForVolunteering.tr(),
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
          LocaleKeys.participateInVolunteering.tr(),
          style: SerManosTextStyle.headline02(),
        ),
        const SizedBox(height: 8),
        MarkdownBody(
          data: formattedRequirements,
          styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)),
          softLineBreak: true,
        ),
        const SizedBox(height: 8),
        Text(
          LocaleKeys.cost,
          style: SerManosTextStyle.headline02(),
        ).plural(
            10,
            format: NumberFormat.simpleCurrency(
                locale: context.locale.toString(),
                name: LocaleKeys.currency.tr(),
                decimalDigits: 2
            )
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
