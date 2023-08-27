import 'package:flutter/material.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class Credits extends StatelessWidget {
  const Credits({super.key});

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return Text(
          'credits: ${currentUser.aiCredits}',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 24,
            color: currentUser.isOutOfCredits ? Colors.red : Colors.white,
          ),
        );
      },
    );
  }
}
