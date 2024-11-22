import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';

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
            foregroundColor: SerManosColors.primary100,
            backgroundColor: SerManosColors.primary10,
            disabledForegroundColor: SerManosColors.neutral25,
            disabledBackgroundColor: SerManosColors.neutral10,
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