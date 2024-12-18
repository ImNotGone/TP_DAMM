import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
import '../../translations/locale_keys.g.dart';


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
                    title: LocaleKeys.personalInformation.tr(),
                    label1: LocaleKeys.birthDate.tr(),
                    content1: DateFormat('dd/MM/yyyy').format(currentUser.birthDate!),
                    label2: LocaleKeys.gender.tr(),
                    content2: currentUser.gender!.localizedName(context),
                  ),
                  const SizedBox(height: 32),
                  InfoCard(
                    title: LocaleKeys.contactData.tr(),
                    label1: LocaleKeys.cellphone.tr(),
                    content1: currentUser.phoneNumber!,
                    label2: LocaleKeys.email.tr(),
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
                      LocaleKeys.completeProfile.tr(),
                      textAlign: TextAlign.center,
                      style: SerManosTextStyle.body01().copyWith(color: SerManosColors.neutral75),
                  ),
                ],
              ),
            editButton: UtilShortButton(
                onPressed: () => context.push('/profile_edit'),
                text: LocaleKeys.complete.tr(),
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
                    LocaleKeys.volunteer.tr().toUpperCase(),
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
                    text: LocaleKeys.editProfile.tr(),
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
      ref.invalidate(volunteeringsNotifierProvider);
      ref.invalidate(currentUserNotifierProvider);
      ref.invalidate(volunteeringsNotifierProvider);
      ref.invalidate(newsNotifierProvider);
      ref.invalidate(appStateNotifierProvider);
      userService.signOut();
    }

    return SizedBox(
      height: 44,
      child: UtilTextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => Modal(
              confirmButtonText: LocaleKeys.logOut.tr(),
              onConfirm: signOut,
              context: context,
              child: Text(
                LocaleKeys.sureToLogOut.tr(),
                style: SerManosTextStyle.subtitle01(),
              ),
            ),
          );
        },
        text: LocaleKeys.signOut.tr(),
        foregroundColor: SerManosColors.error100,
      ),
    );
  }
}