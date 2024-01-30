import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/forms/username_text_field.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';

class OnboardingUsernameView extends StatelessWidget {
  const OnboardingUsernameView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "what's your handle?",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Rubik One',
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            UsernameTextField(
              onChanged: (input) => context
                  .read<OnboardingFlowCubit>()
                  .usernameChange(input ?? ''),
              initialValue: state.username.value,
            ),
          ],
        );
      },
    );
  }
}
