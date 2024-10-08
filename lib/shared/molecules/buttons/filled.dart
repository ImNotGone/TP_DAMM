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
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary
        ),
        child: Text(text)
    );
  }
}