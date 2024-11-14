import 'package:flutter/material.dart';
import 'validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PasswordValidation implements Validation<String> {
  const PasswordValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      // Required se encarga de esto
      return null;
    }
    if (value.length < 8) {
      return AppLocalizations.of(context)!.invalidPasswordError;
    }
    return null;
  }
}