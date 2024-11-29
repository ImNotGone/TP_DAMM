import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import 'package:ser_manos_mobile/shared/tokens/shadows.dart';

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
        child: DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: SerManosShadows.shadow3
            ),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                foregroundColor: SerManosColors.primary100,
                backgroundColor: SerManosColors.primary10,
                disabledForegroundColor: SerManosColors.neutral25,
                disabledBackgroundColor: SerManosColors.neutral10,
                elevation: 0,
                shadowColor: Colors.transparent,
                padding: EdgeInsets.zero
            ),
            child: const Icon(
              Icons.near_me,
              size: 24,
            ),
          ),
        )
    );
  }
}