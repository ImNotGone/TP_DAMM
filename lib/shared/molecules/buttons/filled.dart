import 'package:flutter/material.dart';
import 'package:ser_manos_mobile/shared/tokens/colors.dart';
import 'package:ser_manos_mobile/shared/tokens/text_style.dart';

class UtilFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isLoading;

  const UtilFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.isLoading = false
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: isLoading?  null : onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0)
            ),
            minimumSize: const Size(double.infinity, 44),
            backgroundColor: SerManosColors.primary100,
            foregroundColor: SerManosColors.neutral0,
        ),

        child: isLoading
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                    color: SerManosColors.primary100
                ),
              )
            : Text(
                text,
                style: SerManosTextStyle.button(),
            ),
    );
  }
}

class UtilShortButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final double? maxHeight;

  const UtilShortButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.maxHeight
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxHeight ?? 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(
            text,
            style: SerManosTextStyle.button(),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: SerManosColors.primary100,
          foregroundColor: SerManosColors.neutral0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      )
    );
  }
}


class UtilTinyShortButton extends UtilShortButton {
  const UtilTinyShortButton({
    super.key,
    required super.onPressed,
    required super.text,
    required super.icon
  }) : super(
    maxHeight: 40
  );
}