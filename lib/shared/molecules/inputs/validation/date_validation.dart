import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validation.dart';

import '../../../../translations/locale_keys.g.dart';

class DateValidation extends Validation<String> {
  const DateValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final dateFormat = DateFormat(LocaleKeys.dateFormat.tr());

    try {
      // Si esto falla, es invalido
      final parsedDate = dateFormat.parseStrict(value);

      // Que no sea en el futuro
      if (parsedDate.isAfter(DateTime.now())) {
        return LocaleKeys.dateInFutureError.tr();
      }
    } catch (e) {
      return LocaleKeys.invalidDateError.tr();
    }

    return null;
  }
}