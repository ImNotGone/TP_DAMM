import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';
import 'package:ser_manos_mobile/shared/cells/cards/info_card.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';

import '../../shared/cells/modals/modal.dart';
import '../../shared/molecules/buttons/text.dart';


class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return currentUser!.isComplete()
        ? const _UserData()
        : const _MissingDataScreen();
  }
}

class _UserData extends HookConsumerWidget {
  const _UserData();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    final userService = ref.read(userServiceProvider);

    void signOut() {
      userService.signOut();
      ref.read(currentUserNotifierProvider.notifier).clearUser();
      GoRouter.of(context).go('/');
    }

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        currentUser!.profilePictureURL!,
                        width: 110,
                        height: 110,
                      ),
                      const SizedBox(height: 16),
                      Text(
                          AppLocalizations.of(context)!.volunteer.toUpperCase(),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xff666666))
                      ),
                      const SizedBox(height: 2),
                      Text(
                          '${currentUser.firstName} ${currentUser.lastName}',
                          style: Theme.of(context).textTheme.titleMedium
                      ),
                      const SizedBox(height: 2),
                      Text(
                          currentUser.email,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xff0d47a1))
                      ),
                      const SizedBox(height: 32),
                      InfoCard(
                          title: AppLocalizations.of(context)!.personalInformation,
                          label1: AppLocalizations.of(context)!.birthDate,
                          content1: DateFormat('dd/MM/yyyy').format(currentUser.birthDate!),
                          label2: AppLocalizations.of(context)!.gender,
                          content2: currentUser.gender!.localizedName(context)
                      ),
                      const SizedBox(height: 32),
                      InfoCard(
                          title: AppLocalizations.of(context)!.contactData,
                          label1: AppLocalizations.of(context)!.cellphone,
                          content1: currentUser.phoneNumber!,
                          label2: AppLocalizations.of(context)!.email,
                          content2: currentUser.email
                      )
                    ],
                  )
              ),
              UtilFilledButton(
                  onPressed: () {
                    context.push('/profile_edit');
                    },
                  text: AppLocalizations.of(context)!.editProfile
              ),
              const SizedBox(height: 8),
              UtilTextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => Modal(
                        confirmButtonText: AppLocalizations.of(context)!.logOut,
                        onConfirm: () {
                          signOut();
                        },
                        context: context,
                        child: Text(
                          AppLocalizations.of(context)!.sureToLogOut,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      )
                  );
                },
                text: AppLocalizations.of(context)!.signOut,
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16), // TODO: revisar
            ],
          ),
        )
    );
  }
}

class _MissingDataScreen extends HookConsumerWidget {
  const _MissingDataScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);
    final userService = ref.read(userServiceProvider);

    void signOut() {
      userService.signOut();
      ref.read(currentUserNotifierProvider.notifier).clearUser();
      GoRouter.of(context).go('/');
    }

    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: currentUser?.profilePictureURL == null ?
                          Image.asset(
                            'assets/no_profile_pic_icon.png',
                            width: 100,
                            height: 100,
                          ) :
                          ClipOval(
                            child: Image.network(
                              currentUser!.profilePictureURL!,
                              fit: BoxFit.cover,
                              width: 100,
                              height: 100,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                            AppLocalizations.of(context)!.volunteer.toUpperCase(),
                            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: const Color(0xff666666))
                        ),
                        const SizedBox(height: 8),
                        Text(
                            '${currentUser!.firstName} ${currentUser.lastName}',
                            style: Theme.of(context).textTheme.titleMedium
                        ),
                        const SizedBox(height: 8),
                        Text(
                            AppLocalizations.of(context)!.completeProfile,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: const Color(0xff666666))
                        ),
                      ],
                    )
                ),
                // TODO: replace with the correct button
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/profile_edit');
                  },
                  icon: const Icon(Icons.add),
                  label: Text(AppLocalizations.of(context)!.complete),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                UtilTextButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => Modal(
                            confirmButtonText: AppLocalizations.of(context)!.logOut,
                            onConfirm: () {
                              signOut();
                            },
                            context: context,
                            child: Text(
                                  AppLocalizations.of(context)!.sureToLogOut,
                                  style: Theme.of(context).textTheme.titleMedium,
                            ),
                        )
                    );
                  },
                  text: AppLocalizations.of(context)!.signOut,
                  foregroundColor: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 16), // TODO: should be 26?
              ],
          ),
        )
    );
  }
}
