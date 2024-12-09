import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ser_manos_mobile/providers/news_provider.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';
import 'package:ser_manos_mobile/providers/volunteering_provider.dart';
import 'package:ser_manos_mobile/shared/cells/cards/info_card.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';

import '../../providers/app_state_provider.dart';
import '../../shared/cells/modals/modal.dart';
import '../../shared/molecules/buttons/text.dart';
import '../../shared/tokens/colors.dart';
import '../../shared/tokens/text_style.dart';


class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);


    return currentUser!.isComplete()
        ? _UserContent(
            profileWidget:
            ClipOval(
              child: Image.network(
                currentUser.profilePictureURL!,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
              ),
            ),

            detailsWidget: Column(
                children: [
                  const SizedBox(height: 2),
                  Text(
                      '${currentUser.firstName} ${currentUser.lastName}',
                      style: SerManosTextStyle.subtitle01()
                  ),
                  const SizedBox(height: 2),
                  Text(
                      currentUser.email,
                      textAlign: TextAlign.center,
                      style: SerManosTextStyle.body01().copyWith(color: SerManosColors.secondary200)
                  ),
                  const SizedBox(height: 32),
                  InfoCard(
                    title: AppLocalizations.of(context)!.personalInformation,
                    label1: AppLocalizations.of(context)!.birthDate,
                    content1: DateFormat('dd/MM/yyyy').format(currentUser.birthDate!),
                    label2: AppLocalizations.of(context)!.gender,
                    content2: currentUser.gender!.localizedName(context),
                  ),
                  const SizedBox(height: 32),
                  InfoCard(
                    title: AppLocalizations.of(context)!.contactData,
                    label1: AppLocalizations.of(context)!.cellphone,
                    content1: currentUser.phoneNumber!,
                    label2: AppLocalizations.of(context)!.email,
                    content2: currentUser.email,
                  ),
                ],
              ),
          )
        : _UserContent(
            profileWidget: Padding(
              padding: const EdgeInsets.all(10),
              child: Image.asset(
                'assets/no_profile_pic_icon.png',
                width: 100,
                height: 100,
              ),
            ),
            detailsWidget:
              Column(
                children: [
                  const SizedBox(height: 8),
                  Text(
                      '${currentUser.firstName} ${currentUser.lastName}',
                      style: SerManosTextStyle.subtitle01()
                  ),
                  const SizedBox(height: 8),
                  Text(
                      AppLocalizations.of(context)!.completeProfile,
                      textAlign: TextAlign.center,
                      style: SerManosTextStyle.body01().copyWith(color: SerManosColors.neutral75),
                  ),
                ],
              ),
            editButton: UtilShortButton(
                onPressed: () => context.push('/profile_edit'),
                text: AppLocalizations.of(context)!.complete,
                icon: Icons.add
            )
          );
  }
}

class _UserContent extends StatelessWidget {
  final Widget profileWidget;
  final Widget detailsWidget;
  final Widget? editButton;


  const _UserContent({
    required this.profileWidget,
    required this.detailsWidget,
    this.editButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SerManosColors.neutral0,
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  profileWidget,
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)!.volunteer.toUpperCase(),
                    style: SerManosTextStyle.overline(),
                  ),
                  detailsWidget,
                ],
              ),
            ),
            editButton ??
                SizedBox(
                  height: 44,
                  child: UtilFilledButton(
                    onPressed: () => context.push('/profile_edit'),
                    text: AppLocalizations.of(context)!.editProfile,
                  ),
                ),
            const SizedBox(height: 8),
            _SignOutButton(),
          ],
        ),
      ),
    );
  }
}

class _SignOutButton extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userService = ref.read(userServiceProvider);

    void signOut() {
      ref.read(volunteeringsStreamNotifierProvider.notifier).clearStream();
      userService.signOut();
      ref.read(currentUserNotifierProvider.notifier).clearUser();
      ref.read(volunteeringsNotifierProvider.notifier).clearVolunteerings();
      ref.read(newsNotifierProvider.notifier).clearNews();
      ref.read(appStateNotifierProvider.notifier).unauthenticate();
    }

    return SizedBox(
      height: 44,
      child: UtilTextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => Modal(
              confirmButtonText: AppLocalizations.of(context)!.logOut,
              onConfirm: signOut,
              context: context,
              child: Text(
                AppLocalizations.of(context)!.sureToLogOut,
                style: SerManosTextStyle.subtitle01(),
              ),
            ),
          );
        },
        text: AppLocalizations.of(context)!.signOut,
        foregroundColor: SerManosColors.error100,
      ),
    );
  }
}