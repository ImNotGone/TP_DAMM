import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validation.dart';

import '../../../../translations/locale_keys.g.dart';

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
      return LocaleKeys.invalidEmailError.tr();
    }

    return null;
  }
}