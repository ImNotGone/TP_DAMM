import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validation.dart';

import '../../../../translations/locale_keys.g.dart';

class RequiredValidation<T> extends Validation<T> {
  const RequiredValidation();

  @override
  String? validate(BuildContext context, T? value) {
    if (value == null) {
      return LocaleKeys.requiredError.tr();
    }

    if (value is String && (value as String).isEmpty) {
      return LocaleKeys.requiredError.tr();
    }

    return null;
  }
}