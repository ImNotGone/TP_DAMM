import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ser_manos_mobile/home/presentation/profile_edit_screen.dart';
import 'package:ser_manos_mobile/providers/service_providers.dart';
import 'package:ser_manos_mobile/providers/user_provider.dart';


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
      //TODO: return to login screen
    }

    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: Colors.blue[100],
          child: currentUser?.profilePictureURL == null
              ? Icon(
                  Icons.person,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                )
              : ClipOval(
                  child: Image.network(
                    currentUser!.profilePictureURL!,
                    fit: BoxFit.cover,
                    width: 100,
                    height: 100,
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
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            signOut();
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
