import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';

abstract final class SerManosTextStyle {
  static TextStyle headline01() => const TextStyle(
    fontSize: 24.0,
    fontWeight: FontWeight.w400,
    color: SerManosColors.neutral100,
    letterSpacing: 0.18,
    height: 1.0
  );

  static TextStyle headline02() => const TextStyle(
    fontSize: 20.0,
    fontWeight: FontWeight.w500,
    color: SerManosColors.neutral100,
    letterSpacing: 0.15,
    height: 1.2
  );

  static TextStyle subtitle01() => const TextStyle(
    fontSize: 16.0,
    fontWeight: FontWeight.w400,
    color: SerManosColors.neutral100,
    letterSpacing: 0.15,
    height: 1.5
  );

  static TextStyle body01() => const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w400,
    color: SerManosColors.neutral100,
    letterSpacing: 0.25,
    height: 1.43
  );

  static TextStyle body02() => const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: SerManosColors.neutral100,
    letterSpacing: 0.4,
    height: 1.34
  );

  static TextStyle button() => const TextStyle(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    // no color so it inherits from the button
    letterSpacing: 0.1,
    height: 1.43
  );

  static TextStyle caption() => const TextStyle(
    fontSize: 12.0,
    fontWeight: FontWeight.w400,
    color: SerManosColors.neutral100,
    letterSpacing: 0.4,
    height: 1.34
  );

  static TextStyle overline() => const TextStyle(
    fontSize: 10.0,
    fontWeight: FontWeight.w500,
    // neutral 75, because its used like this in all the app
    color: SerManosColors.neutral75,
    letterSpacing: 1.5,
    height: 1.6
  );
}