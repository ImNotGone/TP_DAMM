import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../auth/domain/app_user.dart';
import '../../providers/service_providers.dart';
import '../../providers/user_provider.dart';


class ProfileEditScreen extends HookConsumerWidget {
  const ProfileEditScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserNotifierProvider); // Watching the current user
    final userService = ref.read(userServiceProvider); // Accessing the user service

    // Controllers
    final birthDateController = useTextEditingController(text: user?.birthDate != null ? DateFormat('dd/MM/yyyy').format(user!.birthDate!) : '');
    final phoneNumberController = useTextEditingController(text: user?.phoneNumber ?? '');
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
        final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          File imageFile = File(pickedFile.path);
          userService.uploadProfilePicture(imageFile);
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
        userService.updateUser(updatedUser); // Assuming updateUser method exists in userService
        ref.read(currentUserNotifierProvider.notifier).setUser(updatedUser);

        Navigator.pop(context); // Close the screen after saving
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Datos de perfil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: saveProfile,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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
              const Text('Información de perfil', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioListTile<Gender>(
                title: const Text('Hombre'),
                value: Gender.male,
                groupValue: selectedGender.value,
                onChanged: (Gender? value) {
                  selectedGender.value = value;
                },
              ),
              RadioListTile<Gender>(
                title: const Text('Mujer'),
                value: Gender.female,
                groupValue: selectedGender.value,
                onChanged: (Gender? value) {
                  selectedGender.value = value;
                },
              ),
              RadioListTile<Gender>(
                title: const Text('No binario'),
                value: Gender.nonBinary,
                groupValue: selectedGender.value,
                onChanged: (Gender? value) {
                  selectedGender.value = value;
                },
              ),
              const SizedBox(height: 16.0),
              const Text('Foto de perfil', style: TextStyle(fontWeight: FontWeight.bold)),
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
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                child: const Text('Guardar datos'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
