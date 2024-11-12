import 'package:flutter/material.dart';

class UtilTextButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const UtilTextButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4),
          ),
          minimumSize: const Size(double.infinity, 44),
          foregroundColor: Theme.of(context).colorScheme.primary
      ),
      child: Text(text),
    );
  }
}