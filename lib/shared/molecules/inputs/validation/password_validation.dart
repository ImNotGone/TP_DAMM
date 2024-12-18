import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../../../translations/locale_keys.g.dart';
import 'validation.dart';

class PasswordValidation implements Validation<String> {
  const PasswordValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      // Required se encarga de esto
      return null;
    }
    if (value.length < 8) {
      return LocaleKeys.invalidPasswordError.tr();
    }
    return null;
  }
}