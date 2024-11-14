import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/molecules/inputs/validation/validation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RequiredValidation<T> extends Validation<T> {
  const RequiredValidation();

  @override
  String? validate(BuildContext context, T? value) {
    if (value == null) {
      return AppLocalizations.of(context)!.requiredError;
    }

    if (value is String && (value as String).isEmpty) {
      return AppLocalizations.of(context)!.requiredError;
    }

    return null;
  }
}