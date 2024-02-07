import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_form.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_complete_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_init_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_profile_picture_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_social_media_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_username_view.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/utils/app_logger.dart';

class OnboardingForm extends StatelessWidget {
  const OnboardingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        if (state.status.isInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        return TappedForm(
          onSubmit: () {
            context
                .read<OnboardingFlowCubit>()
                .finishOnboarding()
                .onError((error, stackTrace) {
              logger.error(
                'Error completing onboarding',
                error: error,
                stackTrace: stackTrace,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.red,
                  content: Text(error.toString()),
                ),
              );
            });
          },
          questions: [
            (
              const OnboardingInitView(),
              () => true,
            ),
            (
              const OnboardingUsernameView(),
              () => context.read<OnboardingFlowCubit>().state.username.isValid,
            ),
            (
              const OnboardingProfilePictureView(),
              () =>  true,
            ),
            (
              const OnboardingSocialMediaView(),
              () => true,
            ),
            (
              const OnboardingCompleteView(),
              () => context.read<OnboardingFlowCubit>().state.eula,
            ),
          ],
        );
      },
    );
  }
}
