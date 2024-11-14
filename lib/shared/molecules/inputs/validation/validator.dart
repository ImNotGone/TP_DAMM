import 'package:flutter/material.dart';
import 'validation.dart';

class Validator {
  // Constructor privado
  Validator._();

  // Aplica una lista de validaciones a un campo
  static FormFieldValidator<T> apply<T>(
      BuildContext context, List<Validation<T>> validations) {
    return (T? value) {
      for (final validation in validations) {
        final error = validation.validate(context, value);
        if (error != null) return error;
      }

      return null;
    };
  }
}