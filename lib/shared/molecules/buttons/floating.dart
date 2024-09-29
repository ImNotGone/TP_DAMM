import 'dart:math';

import 'package:flutter/material.dart';

class UtilFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData? icon;

  const UtilFloatingButton({
    super.key,
    required this.onPressed,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 48.0,
        width: 48.0,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4), // Border radius of 4
            ),
            foregroundColor: const Color(0xFF14903F),
            backgroundColor: const Color(0xFFE7F4EC),
            disabledForegroundColor: const Color(0xFFE0E0E0),
            disabledBackgroundColor: const Color(0xFFFAFAFA),
            elevation: 4.0, // Shadow depth
            padding: EdgeInsets.zero
          ),
          child: Transform.rotate(
            angle: 45 * pi / 180,
            child: Icon(
              icon,
              size: 24,
            ),
          ),
        ),
    );
  }
}