import 'package:flutter/material.dart';

class PasswordVisibilityIcon extends StatelessWidget {
  final bool isVisible;
  final VoidCallback onTap;

  const PasswordVisibilityIcon({
    super.key,
    required this.isVisible,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isVisible ? Icons.visibility : Icons.visibility_off,
      ),
      onPressed: onTap,
    );
  }
}
