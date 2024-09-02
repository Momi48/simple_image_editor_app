import 'package:flutter/material.dart';

class DefaultButtons extends StatelessWidget {
  final Widget child;
  final VoidCallback onPressed;
  final Color colors;
  final Color textColor;
  const DefaultButtons(
      {super.key,
      required this.child,
      required this.onPressed,
      required this.colors,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(colors),
          foregroundColor: WidgetStateProperty.all(textColor)),
      child: child,
    );
  }
}
