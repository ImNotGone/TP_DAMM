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
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/email_validation.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/phone_validation.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/required_validation.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validator.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import '../../auth/domain/app_user.dart';
import '../../shared/tokens/text_style.dart';
import '../../volunteer/application/volunteering_service.dart';
import '../../volunteer/domain/volunteering.dart';
import '../../providers/service_providers.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/volunteering_provider.dart';
import '../../shared/molecules/inputs/text_input.dart';
import '../../shared/cells/modals/modal.dart';

final formKey = GlobalKey<FormState>();

class ProfileEditScreen extends HookConsumerWidget {
  final String? volunteeringId;

  const ProfileEditScreen({super.key, this.volunteeringId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(currentUserNotifierProvider);
    final userService = ref.read(userServiceProvider);

    final isSaveDataEnabled = useState(user?.isComplete() ?? false);
    final isLoading = useState(false);

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

    Future<void> pickImage(ImageSource source) async {
      try {
        final XFile? pickedFile = await picker.pickImage(source: source);
        if (pickedFile != null) {
          pickedImage.value = File(pickedFile.path);
         }
      } catch (e) {
        log('Error picking image: $e');
      }
    }

    void showImageSourceDialog() {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.chooseImageSource),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(AppLocalizations.of(context)!.camera),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: Text(AppLocalizations.of(context)!.gallery),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text(AppLocalizations.of(context)!.cancel),
              ),
            ],
          );
        },
      );
    }

    Future<void> applyChangesWithVolunteering() async {
      if (user != null) {
        final VolunteeringService volunteeringService =
            ref.read(volunteeringServiceProvider);

        try {
          Volunteering? updatedVolunteering = await volunteeringService
              .volunteerToVolunteering(volunteeringId!, user.uid);

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
          if(context.mounted) {
            context.pop();
          }
          userService.updateUser(updatedUser);
        } catch (e) {
          log('Error updating user: $e');
          volunteeringService.unvolunteerToVolunteering(volunteeringId!, user.uid);
          ref.read(currentUserNotifierProvider.notifier).setUser(user);
        }
      }
    }

    Future<void> applyChangesNoVolunteering() async {
      isLoading.value = true;
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
          if(context.mounted){
            context.pop();
          }
          userService.updateUser(updatedUser);
        } catch (e) {
          log('Error updating user: $e');
          ref.read(currentUserNotifierProvider.notifier).setUser(user);
        }
      }
      isLoading.value = false;
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
                        style: SerManosTextStyle.subtitle01(),
                      ),
                      Text(
                        ref
                            .read(
                                volunteeringsNotifierProvider)![volunteeringId]!
                            .title,
                        style: SerManosTextStyle.headline02()
                      ),
                    ],
                  ),
                );
              });
        } else {
          applyChangesNoVolunteering();
        }
      }
    }

    void handleGenderSelection(Gender gender) {
      selectedGender.value = gender;
    }

    return Scaffold(
      backgroundColor: SerManosColors.neutral0,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.close),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            onChanged: () {
              isSaveDataEnabled.value = formKey.currentState?.validate() ?? false;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.profileData,
                  style: SerManosTextStyle.headline01(),
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
                    previousGender: selectedGender.value
                ),
                const SizedBox(height: 24),
                pickedImage.value == null
                    ? (user?.profilePictureURL == null
                        ? UploadProfilePictureCard(onUploadPicture: showImageSourceDialog)
                        : ChangeProfilePictureCard(
                            onUploadPicture: showImageSourceDialog,
                            profilePictureUrl: user!.profilePictureURL!))
                    : ChangeProfilePictureCard(
                        onUploadPicture: showImageSourceDialog,
                        pickedImage: pickedImage.value),
                const SizedBox(height: 32),
                Text(
                  AppLocalizations.of(context)!.contactData,
                  style: SerManosTextStyle.headline01(),
                ),
                const SizedBox(height: 24),
                Text(
                  AppLocalizations.of(context)!.contactDataDetail,
                  style: SerManosTextStyle.subtitle01(),
                ),
                const SizedBox(height: 24),
                TextInput(
                  label: AppLocalizations.of(context)!.cellphone,
                  hintText: AppLocalizations.of(context)!.cellphoneHint,
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: Validator.apply(context, [
                      const RequiredValidation(),
                      const PhoneValidation(),
                    ]
                  ),
                ),
                const SizedBox(height: 24),
                TextInput(
                  label: AppLocalizations.of(context)!.email,
                  hintText: AppLocalizations.of(context)!.emailHint,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: Validator.apply(context, [
                      const RequiredValidation(),
                      const EmailValidation(),
                    ]
                  ),
                ),
                const SizedBox(height: 32),
                UtilFilledButton(
                  onPressed: isSaveDataEnabled.value ?
                  () {
                    saveProfile();
                  } : null,
                  text: AppLocalizations.of(context)!.saveData,
                  isLoading: isLoading.value,
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
