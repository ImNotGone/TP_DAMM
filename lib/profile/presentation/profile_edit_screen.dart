import 'dart:developer';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
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
import '../../translations/locale_keys.g.dart';
import '../../volunteer/application/volunteering_service.dart';
import '../../volunteer/domain/volunteering.dart';
import '../../providers/service_providers.dart';
import '../../providers/user_provider.dart';

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
            ? DateFormat(LocaleKeys.dateFormat.tr()).format(user!.birthDate!)
            : '');
    final phoneNumberController = useTextEditingController(text: user?.phoneNumber ?? '');
    final emailController = useTextEditingController(text: user?.email ?? '');

    final birthDateFocusNode = useFocusNode();
    final phoneNumberFocusNode = useFocusNode();
    final emailFocusNode = useFocusNode();

    final selectedDate = useState<DateTime?>(user?.birthDate);
    final selectedGender = useState<Gender?>(user?.gender);
    final profilePictureUrl = useState<String?>(user?.profilePictureURL);
    final pickedImage = useState<File?>(null);

    final ImagePicker picker = ImagePicker();

    void validateForm(){
      isSaveDataEnabled.value = (formKey.currentState?.validate() ?? false) && selectedGender.value != null && (profilePictureUrl.value != null || pickedImage.value != null);
    }

    Future<void> pickImage(ImageSource source) async {
      try {
        final XFile? pickedFile = await picker.pickImage(source: source);
        if (pickedFile != null) {
          pickedImage.value = File(pickedFile.path);
          validateForm();
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
            title: Text(LocaleKeys.chooseImageSource.tr()),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: Text(LocaleKeys.camera.tr()),
                  onTap: () {
                    Navigator.pop(context); // Close the dialog
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo),
                  title: Text(LocaleKeys.gallery.tr()),
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
                child: Text(LocaleKeys.cancel.tr()),
              ),
            ],
          );
        },
      );
    }

    Future<void> applyChangesWithVolunteering() async {
      isLoading.value = true;
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
                ? DateFormat(LocaleKeys.dateFormat.tr()).parse(birthDateController.text)
                : null,
            gender: selectedGender.value,
            phoneNumber: phoneNumberController.text,
            profilePictureURL: photoURL,
          ) :
          updatedUser.copyWith(
            birthDate: birthDateController.text.isNotEmpty
                ? DateFormat(LocaleKeys.dateFormat.tr()).parse(birthDateController.text)
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
      isLoading.value = false;
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
              ? DateFormat(LocaleKeys.dateFormat.tr()).parse(birthDateController.text)
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
                  confirmButtonText: LocaleKeys.confirm.tr(),
                  onConfirm: () {
                    applyChangesWithVolunteering();
                  },
                  context: context,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        LocaleKeys.youAreApplyingTo.tr(),
                        style: SerManosTextStyle.subtitle01(),
                      ),
                      Text(
                        ref
                            .read(
                                volunteeringsNotifierProvider).value![volunteeringId]!
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
      validateForm();
    }

    return Scaffold(
      backgroundColor: SerManosColors.neutral0,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: SerManosColors.neutral0
        ),
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
            onChanged: validateForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LocaleKeys.profileData.tr(),
                  style: SerManosTextStyle.headline01(),
                ),
                const SizedBox(height: 24),
                CalendarInput(
                  focusNode: birthDateFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                  },
                  initialDate: selectedDate.value,
                  label: LocaleKeys.birthDate.tr(),
                  controller: birthDateController,
                ),
                const SizedBox(height: 24),
                InputCard(
                    onGenderSelected: handleGenderSelection,
                    previousGender: selectedGender.value
                ),
                if (selectedGender.value == null)
                  Padding(padding: EdgeInsets.only(left: 14),
                    child: Text(
                      LocaleKeys.requiredError.tr(),
                      style: SerManosTextStyle.body02().copyWith(color: SerManosColors.error100),
                    ),
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
                if (profilePictureUrl.value == null && pickedImage.value == null)
                  Padding(padding: EdgeInsets.only(left: 14),
                    child: Text(
                      LocaleKeys.requiredError.tr(),
                      style: SerManosTextStyle.body02().copyWith(color: SerManosColors.error100),
                    ),
                  ),
                const SizedBox(height: 32),
                Text(
                  LocaleKeys.contactData.tr(),
                  style: SerManosTextStyle.headline01(),
                ),
                const SizedBox(height: 24),
                Text(
                  LocaleKeys.contactDataDetail.tr(),
                  style: SerManosTextStyle.subtitle01(),
                ),
                const SizedBox(height: 24),
                UtilTextInput(
                  focusNode: phoneNumberFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(emailFocusNode);
                  },
                  label: LocaleKeys.cellphone.tr(),
                  hintText: LocaleKeys.cellphoneHint.tr(),
                  controller: phoneNumberController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.next,
                  validator: Validator.apply(context, [
                      const RequiredValidation(),
                      const PhoneValidation(),
                    ]
                  ),
                ),
                const SizedBox(height: 24),
                UtilTextInput(
                  focusNode: emailFocusNode,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                    /*
                    Quizas el usuario quiere seguir cambiando cosas asi que lo comento
                    if(isSaveDataEnabled.value) {
                      saveProfile();
                    }
                    */
                  },
                  label: LocaleKeys.email.tr(),
                  hintText: LocaleKeys.emailHint.tr(),
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
                  onPressed: isSaveDataEnabled.value ? saveProfile : null,
                  text: LocaleKeys.saveData.tr(),
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
