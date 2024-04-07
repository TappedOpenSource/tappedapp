import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/onboarding/components/eula_button.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';

class OnboardingCompleteView extends StatelessWidget {
  const OnboardingCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(height: 25),
            Container(
              height: MediaQuery.of(context).size.height / 2.5,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/splash.gif'),
                ),
              ),
            ),
            const SizedBox(height: 25),
            // const Spacer(),
            const Text(
              "you're all set!",
              style: TextStyle(
                fontSize: 24,
                fontFamily: 'Rubik One',
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'you can edit your profile at any time by going to your settings and if you want to get verified, post a screenshot of your profile to your instagram story and tag us @tappedai',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const Spacer(),
            EULAButton(
              initialValue: state.eula,
              onChanged: (input) => context
                  .read<OnboardingFlowCubit>()
                  .eulaChange(input ?? false),
            ),
          ],
        );
      },
    );
  }
}
