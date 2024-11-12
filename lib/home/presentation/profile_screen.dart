import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/home/presentation/profile_edit_screen.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';

import '../../shared/cells/modals/modal.dart';


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

    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 100.0, // Adjust the size as needed
              height: 100.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).colorScheme.secondary, // Border color
                  width: 10.0, // Border width
                ),
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Theme.of(context).colorScheme.surface,
                child: Icon(
                  color: Theme.of(context).colorScheme.secondary,
                  Icons.person_outline,
                  size: 80,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppLocalizations.of(context)!.volunteer.toUpperCase(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              currentUser!.firstName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              AppLocalizations.of(context)!.completeProfile,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 80),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const ProfileEditScreen();
                }));
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
            TextButton(
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
              child: Text(
                AppLocalizations.of(context)!.signOut,
                style: const TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
      )
    );
  }
}
