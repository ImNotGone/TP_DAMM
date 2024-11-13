import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';

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
    return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text('Complete User Data Screen')]));
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
      GoRouter.of(context).go('/login');
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
                          'assets/no_profile_pic_icon.png',
                          width: 120,
                          height: 120,
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
