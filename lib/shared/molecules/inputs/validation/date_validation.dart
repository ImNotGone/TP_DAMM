import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';

class DateValidation extends Validation<String> {
  const DateValidation();

  @override
  String? validate(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final dateFormat = DateFormat('dd/MM/yyyy');

    try {
      // Si esto falla, es invalido
      final parsedDate = dateFormat.parseStrict(value);

      // Que no sea en el futuro
      if (parsedDate.isAfter(DateTime.now())) {
        return AppLocalizations.of(context)!.dateInFutureError;
      }
    } catch (e) {
      return AppLocalizations.of(context)!.invalidDateError;
    }

    return null;
  }
}