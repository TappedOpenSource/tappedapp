import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class OnboardingInitView extends StatelessWidget {
  const OnboardingInitView({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 25),
        const Text(
          "let's get you set up...",
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Rubik One',
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'this info will help get you get booked',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.grey,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            context.authentication.add(LoggedOut());
          },
          child: const Text(
            'sign into a different account?',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }
}
