import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ser_manos_mobile/shared/cells/cards/info_card.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import '../../auth/domain/app_user.dart';
import '../../providers/service_providers.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileEditScreen extends HookConsumerWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user =
        ref.watch(currentUserNotifierProvider); // Watching the current user
    final userService =
        ref.read(userServiceProvider); // Accessing the user service

    // Controllers
    final birthDateController = useTextEditingController(
        text: user?.birthDate != null
            ? DateFormat('dd/MM/yyyy').format(user!.birthDate!)
            : '');
    final phoneNumberController =
        useTextEditingController(text: user?.phoneNumber ?? '');
    final emailController = useTextEditingController(text: user?.email ?? '');

    final selectedDate = useState<DateTime?>(user?.birthDate);
    final selectedGender = useState<Gender?>(user?.gender);
    final profilePictureUrl = useState<String?>(user?.profilePictureURL);

    final ImagePicker picker = ImagePicker();

    Future<void> selectDate(BuildContext context) async {
      final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: selectedDate.value ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );
      if (pickedDate != null) {
        selectedDate.value = pickedDate;
        birthDateController.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      }
    }

    Future<void> pickImage() async {
      try {
        final XFile? pickedFile =
            await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          String? photoURL = await userService.uploadProfilePicture(imageFile);
          AppUser? updatedUser = user?.copyWith(profilePictureURL: photoURL);
          ref.read(currentUserNotifierProvider.notifier).setUser(updatedUser);
        }
      } catch (e) {
        log('Error picking image: $e');
      }
    }

    void saveProfile() {
      if (user != null) {
        final updatedUser = user.copyWith(
          birthDate: selectedDate.value,
          gender: selectedGender.value,
          phoneNumber: phoneNumberController.text,
          profilePictureURL: profilePictureUrl.value,
        );

        // Call the user service to update the profile
        userService.updateUser(
            updatedUser); // Assuming updateUser method exists in userService
        ref.read(currentUserNotifierProvider.notifier).setUser(updatedUser);

        Navigator.pop(context); // Close the screen after saving
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: ()  => context.pop(),
            icon: const Icon(Icons.close),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context)!.profileData,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            // TODO: date field
            const SizedBox(height: 24),
            ProfileInfoCard(onGenderSelected: _handleGenderSelection),
            const SizedBox(height: 24),
            // TODO: ProfilePictureCard
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context)!.contactData,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            Text(
              AppLocalizations.of(context)!.contactDataDetail,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 24),
            // TODO: cellphoneField
            const SizedBox(height: 24),
            // TODO: emailField
            const SizedBox(height: 32),
            UtilFilledButton(
                onPressed: null,
                text: AppLocalizations.of(context)!.saveData
            ),
            const SizedBox(height: 16),
          ],
        )
      ),
    );
  }

  void _handleGenderSelection(String gender) {
    debugPrint(gender);
  }
}

/*
Form(
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: birthDateController,
                decoration: InputDecoration(
                  labelText: 'Fecha de nacimiento',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => selectDate(context),
                  ),
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16.0),
              const ProfileInfoCard(),
              const SizedBox(height: 16.0),
              const Text('Foto de perfil',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Subir foto'),
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: phoneNumberController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  hintText: '+541178445459',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Mail',
                  hintText: 'mimail@mail.com',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese un email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: const Text('Guardar datos'),
              ),
            ],
          ),
        ),
 */