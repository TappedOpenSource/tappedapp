import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AppleLoginButton extends StatelessWidget {
  const AppleLoginButton({super.key, this.onPressed});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return CupertinoButton(
      onPressed: onPressed,
      color: onSurface.withOpacity(0.1),
      borderRadius: BorderRadius.circular(15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            FontAwesomeIcons.apple,
            size: 20,
            color: onSurface,
          ),
          const SizedBox(width: 10),
          Text(
            'Continue with Apple',
            style: TextStyle(
              color: onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
