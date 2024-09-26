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
          foregroundColor: Theme.of(context).colorScheme.secondary
      ),
      child: Text(text),
    );
  }
}