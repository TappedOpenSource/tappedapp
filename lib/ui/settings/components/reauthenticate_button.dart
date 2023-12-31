import 'package:flutter/cupertino.dart';

class ReauthenticateButton extends StatelessWidget {
  const ReauthenticateButton({this.onPressed, super.key});

  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton.filled(
          onPressed: onPressed,
          child: const Text('Reauth'),
        );
  }
}
