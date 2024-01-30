import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/onboarding/components/profile_picture_uploader.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';

class OnboardingProfilePictureView extends StatelessWidget {
  const OnboardingProfilePictureView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        return const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ProfilePictureUploader(),
          ],
        );
      },
    );
  }
}
