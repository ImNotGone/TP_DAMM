import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validation.dart';

import '../../../../translations/locale_keys.g.dart';

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
      return LocaleKeys.invalidPhoneError.tr();
    }

    return null;
  }
}