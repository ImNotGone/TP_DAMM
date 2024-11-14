import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PhoneValidation extends Validation<String> {
  const PhoneValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    // Regex para numeros argentinos
    final phoneRegex = RegExp(
        r'^(?:\+54\s?)?(?:\d{2,4}\s?)?\d{6,8}$'
    );

    if (!phoneRegex.hasMatch(value)) {
      return AppLocalizations.of(context)!.invalidPhoneError;
    }

    return null;
  }
}