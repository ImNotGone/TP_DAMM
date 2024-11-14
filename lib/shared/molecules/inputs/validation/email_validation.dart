import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailValidation extends Validation<String> {
  const EmailValidation();

  @override
  String? validate(BuildContext context, String? value) {
    // Este caso la maneja el required validation
    if (value == null || value.isEmpty) {
      return null;
    }

    // regex para mails
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidEmailError;
    }

    return null;
  }
}