import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/forms/instagram_followers_text_field.dart';
import 'package:intheloopapp/ui/forms/instagram_text_field.dart';
import 'package:intheloopapp/ui/forms/tiktok_followers_text_field.dart';
import 'package:intheloopapp/ui/forms/tiktok_text_field.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';

class OnboardingSocialMediaView extends StatelessWidget {
  const OnboardingSocialMediaView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'what are your socials? (optional)',
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Rubik One',
                fontWeight: FontWeight.bold,
              ),
            ),
            TikTokTextField(
              onChanged: (input) =>
                  context.read<OnboardingFlowCubit>().tiktokHandleChange(input),
              initialValue: state.tiktokHandle,
            ),
            TikTokFollowersTextField(
              onChanged: (input) => context
                  .read<OnboardingFlowCubit>()
                  .tiktokFollowersChange(input),
              initialValue: state.tiktokFollowers,
            ),
            const SizedBox(height: 25),
            InstagramTextField(
              onChanged: (input) => context
                  .read<OnboardingFlowCubit>()
                  .instagramHandleChange(input),
              initialValue: state.instagramHandle,
            ),
            InstagramFollowersTextField(
              onChanged: (input) => context
                  .read<OnboardingFlowCubit>()
                  .instagramFollowersChange(input),
              initialValue: state.instagramFollowers,
            ),
          ],
        );
      },
    );
  }
}
