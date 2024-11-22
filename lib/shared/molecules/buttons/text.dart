import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';

import '../../tokens/text_style.dart';

class UtilTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? minWidth;
  final Color? foregroundColor;

  const UtilTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.minWidth,
    this.foregroundColor
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          minimumSize: Size(minWidth ?? double.infinity, 44),
          foregroundColor: foregroundColor ?? SerManosColors.primary100
      ),
      child: Text(
          text,
          style: SerManosTextStyle.button(),
      ),
    );
  }
}