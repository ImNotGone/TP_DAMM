import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ser_manos_mobile/shared/cells/cards/change_profile_picture_card.dart';
import 'package:ser_manos_mobile/shared/cells/cards/input_card.dart';
import 'package:ser_manos_mobile/shared/cells/cards/upload_profile_picture_card.dart';
import 'package:ser_manos_mobile/shared/molecules/buttons/filled.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/calendar_input.dart';
import '../../auth/domain/app_user.dart';
import '../../home/application/volunteering_service.dart';
import '../../home/domain/volunteering.dart';
import '../../providers/service_providers.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/volunteering_provider.dart';
import '../../shared/molecules/inputs/text_input.dart';
import '../../shared/cells/modals/modal.dart';

class ProfileEditScreen extends HookConsumerWidget {
  final String? volunteeringId;

  const ProfileEditScreen({super.key, this.volunteeringId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserNotifierProvider);
    final userService = ref.read(userServiceProvider);

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
    final pickedImage = useState<File?>(null);

    final ImagePicker picker = ImagePicker();

    Future<void> pickImage() async {
      try {
        final XFile? pickedFile =
            await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          pickedImage.value = File(pickedFile.path);
        }
      } catch (e) {
        log('Error picking image: $e');
      }
    }

    Future<void> applyChangesWithVolunteering() async {
      if (user != null) {
        final VolunteeringService volunteeringService =
            ref.read(volunteeringServiceProvider);

        try {
          Volunteering? updatedVolunteering = await volunteeringService
              .volunteerToVolunteering(volunteeringId!);

          AppUser? updatedUser;

          if (updatedVolunteering != null) {
            ref
                .read(volunteeringsNotifierProvider.notifier)
                .updateVolunteering(updatedVolunteering);
            updatedUser = await userService.applyToVolunteering(volunteeringId!);
          }

          String? photoURL = profilePictureUrl.value;
          if (pickedImage.value != null) {
            photoURL =
                await userService.uploadProfilePicture(pickedImage.value!);
          }

          updatedUser = updatedUser == null ?
          user.copyWith(
            birthDate: birthDateController.text.isNotEmpty
                ? DateFormat('dd/MM/yyyy').parse(birthDateController.text)
                : null,
            gender: selectedGender.value,
            phoneNumber: phoneNumberController.text,
            profilePictureURL: photoURL,
          ) :
          updatedUser.copyWith(
            birthDate: birthDateController.text.isNotEmpty
                ? DateFormat('dd/MM/yyyy').parse(birthDateController.text)
                : null,
            gender: selectedGender.value,
            phoneNumber: phoneNumberController.text,
            profilePictureURL: photoURL,
          );

          ref.read(currentUserNotifierProvider.notifier).setUser(updatedUser);
          userService.updateUser(updatedUser);
          if(context.mounted) {
            context.pop();
          }
        } catch (e) {
          log('Error updating user: $e');
          volunteeringService.unvolunteerToVolunteering(volunteeringId!);
          ref.read(currentUserNotifierProvider.notifier).setUser(user);
        }
      }
    }

    Future<void> applyChangesNoVolunteering() async {
      if (user != null) {
        String? photoURL = profilePictureUrl.value;
        if (pickedImage.value != null) {
          photoURL = await userService.uploadProfilePicture(pickedImage.value!);
        }

        final updatedUser = user.copyWith(
          birthDate: birthDateController.text.isNotEmpty
              ? DateFormat('dd/MM/yyyy').parse(birthDateController.text)
              : null,
          gender: selectedGender.value,
          phoneNumber: phoneNumberController.text,
          profilePictureURL: photoURL,
        );

        try {
          ref.read(currentUserNotifierProvider.notifier).setUser(updatedUser);
          userService.updateUser(updatedUser);
        } catch (e) {
          log('Error updating user: $e');
          ref.read(currentUserNotifierProvider.notifier).setUser(user);
        }
      }
    }

    void saveProfile() async {
      if (context.mounted) {
        if (volunteeringId != null) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Modal(
                  confirmButtonText: AppLocalizations.of(context)!.confirm,
                  onConfirm: () {
                    applyChangesWithVolunteering();
                  },
                  context: context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.youAreApplyingTo,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        ref
                            .read(
                                volunteeringsNotifierProvider)![volunteeringId]!
                            .title,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                );
              });
        } else {
          applyChangesNoVolunteering();
          context.pop();
        }
      }
    }

    void handleGenderSelection(Gender gender) {
      selectedGender.value = gender;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.profileData,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              const SizedBox(height: 24),
              CalendarInput(
                initialDate: selectedDate.value,
                label: AppLocalizations.of(context)!.birthDate,
                controller: birthDateController,
              ),
              const SizedBox(height: 24),
              InputCard(
                  onGenderSelected: handleGenderSelection,
                  previousGender: selectedGender.value),
              const SizedBox(height: 24),
              pickedImage.value == null
                  ? (user?.profilePictureURL == null
                      ? UploadProfilePictureCard(onUploadPicture: pickImage)
                      : ChangeProfilePictureCard(
                          onUploadPicture: pickImage,
                          profilePictureUrl: user!.profilePictureURL!))
                  : ChangeProfilePictureCard(
                      onUploadPicture: pickImage,
                      pickedImage: pickedImage.value),
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
              TextInput(
                label: AppLocalizations.of(context)!.cellphone,
                hintText: AppLocalizations.of(context)!.cellphoneHint,
                controller: phoneNumberController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              TextInput(
                label: AppLocalizations.of(context)!.email,
                hintText: AppLocalizations.of(context)!.emailHint,
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 32),
              UtilFilledButton(
                onPressed: saveProfile,
                text: AppLocalizations.of(context)!.saveData,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
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
