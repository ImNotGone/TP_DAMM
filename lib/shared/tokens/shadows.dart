import 'package:flutter/material.dart';

abstract final class SerManosShadows {
  static List<BoxShadow> shadow1 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      offset: const Offset(0, 1),
      blurRadius: 3,
      spreadRadius: 1,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.30),
      offset: const Offset(0, 1),
      blurRadius: 2,
      spreadRadius: 0,
    ),
  ];
  static List<BoxShadow> shadow2 = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.15),
        offset: const Offset(0, 2),
        blurRadius: 6,
        spreadRadius: 2,
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.30),
        offset: const Offset(0, 1),
        blurRadius: 2,
        spreadRadius: 0,
      ),
  ];
  static List<BoxShadow> shadow3 = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      offset: const Offset(0, 8),
      blurRadius: 12,
      spreadRadius: 6,
    ),
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.30),
      offset: const Offset(0, 4),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];
}