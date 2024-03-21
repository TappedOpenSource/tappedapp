import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_form.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_complete_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_init_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_profile_picture_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_social_media_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_username_view.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';

class OnboardingForm extends StatelessWidget {
  const OnboardingForm({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        if (state.status.isInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        return TappedForm(
          onSubmit: context.read<OnboardingFlowCubit>().finishOnboarding,
          questions: [
            (
              const OnboardingInitView(),
              () => true,
            ),
            (
              const OnboardingUsernameView(),
              () async {
                final currentUserId =
                    context.read<OnboardingFlowCubit>().state.currentUserId;
                final username =
                    context.read<OnboardingFlowCubit>().state.username;
                final usernameIsValid = username.isValid;
                final usernameIsAvailable =
                    await database.checkUsernameAvailability(
                  username.value,
                  currentUserId,
                );

                return usernameIsValid && usernameIsAvailable;
              },
            ),
            (
              const OnboardingProfilePictureView(),
              () => true,
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
