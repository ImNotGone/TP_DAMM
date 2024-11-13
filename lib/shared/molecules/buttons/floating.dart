import 'package:flutter/material.dart';

class UtilFloatingButton extends StatelessWidget {
  final VoidCallback? onPressed;

  const UtilFloatingButton({
    super.key,
    required this.onPressed,
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
          child: const Icon(
              Icons.near_me,
              size: 24,
            ),
        ),
    );
  }
}