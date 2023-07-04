import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      label: const Text(
        'Apple',
        style: TextStyle(
          color: Colors.black,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        backgroundColor: Colors.white,
      ),
      icon: const Icon(
        FontAwesomeIcons.apple,
        color: Colors.black,
      ),
      onPressed: onPressed,
    );
  }
}