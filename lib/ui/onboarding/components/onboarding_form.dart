import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_form.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_complete_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_name_view.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';

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
          onSubmit: context.read<OnboardingFlowCubit>().finishOnboarding,
          onNext: context.read<OnboardingFlowCubit>().nextQuestion,
          questions: [
            FormQuestion(
              validator: () async {
                final artistName =
                    context.read<OnboardingFlowCubit>().state.artistName;

                return artistName.isNotEmpty;
              },
              child: const OnboardingUsernameView(),
            ),
            FormQuestion(
              validator: () => context.read<OnboardingFlowCubit>().state.eula,
              child: const OnboardingCompleteView(),
            ),
          ],
        );
      },
    );
  }
}
