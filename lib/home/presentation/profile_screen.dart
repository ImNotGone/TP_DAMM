import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';

class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserNotifierProvider);

    return currentUser!.isComplete()
        ? const _UserData()
        : _MissingDataScreen(
            username: currentUser.firstName,
          );
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
  final String username;

  const _MissingDataScreen({required this.username});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue[100],
          child: Icon(
            Icons.person,
            size: 50,
            color: Theme.of(context).colorScheme.primary,
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
          username,
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
            // Add your profile completion logic here
          },
          icon: const Icon(Icons.add),
          label: Text(AppLocalizations.of(context)!.complete),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            // Add your logout logic here
          },
          child: Text(
            AppLocalizations.of(context)!.signOut,
            style: const TextStyle(
              color: Colors.red,
            ),
          ),
        ),
      ],
    ));
  }
}
