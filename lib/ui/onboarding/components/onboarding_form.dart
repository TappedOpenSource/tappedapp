import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/ui/forms/username_text_field.dart';
import 'package:intheloopapp/ui/onboarding/components/eula_button.dart';
import 'package:intheloopapp/ui/onboarding/components/profile_picture_uploader.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class OnboardingForm extends StatelessWidget {
  const OnboardingForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingFlowCubit, OnboardingFlowState>(
      builder: (context, state) {
        if (state.status.isInProgress) {
          return const Center(child: CircularProgressIndicator());
        }

        return Form(
          key: state.formKey,
          child: Align(
            alignment: const Alignment(0, -1 / 3),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ArtistNameTextField(
                  //   onChanged: (input) => context
                  //       .read<OnboardingFlowCubit>()
                  //       .aristNameChange(input ?? ''),
                  //   initialValue: state.artistName.value,
                  // ),
                  const Row(
                    children: [
                      Text(
                        'start your journey...',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const ProfilePictureUploader(),
                  const SizedBox(height: 20),
                  UsernameTextField(
                    onChanged: (input) => context
                        .read<OnboardingFlowCubit>()
                        .usernameChange(input ?? ''),
                    initialValue: state.username.value,
                  ),
                  const SizedBox(height: 20),
                  // LocationTextField(
                  //   initialPlaceId: state.placeId.toNullable(),
                  //   initialPlace: state.place.toNullable(),
                  //   onChanged: (place, placeId) => context
                  //       .read<OnboardingFlowCubit>()
                  //       .locationChange(place, placeId),
                  // ),
                  // const SizedBox(height: 20),
                  // BioTextField(
                  //   initialValue: state.bio.value,
                  //   onChanged: (input) => context
                  //       .read<OnboardingFlowCubit>()
                  //       .bioChange(input ?? ''),
                  // ),
                  // const SizedBox(height: 20),
                  EULAButton(
                    initialValue: state.eula,
                    onChanged: (input) => context
                        .read<OnboardingFlowCubit>()
                        .eulaChange(input ?? false),
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton.filled(
                    onPressed: () {
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
                    borderRadius: BorderRadius.circular(15),
                    child: const Text(
                      'Complete Onboarding',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.authentication.add(LoggedOut());
                    },
                    child: const Text(
                      'sign into a different account',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
