import 'package:flutter/material.dart';

class UtilFilledButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const UtilFilledButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0)
            ),
            minimumSize: const Size(double.infinity, 44),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
        ),

        child: Text(text)
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
        label: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
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