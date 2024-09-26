import 'package:flutter/material.dart';

class UtilElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;

  const UtilElevatedButton({
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
              backgroundColor: Theme.of(context).colorScheme.secondary
          ),
          child: Text(text)
    );
  }
}