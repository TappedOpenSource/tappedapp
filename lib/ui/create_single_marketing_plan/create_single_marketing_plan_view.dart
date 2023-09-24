import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/create_single_marketing_plan/cubit/create_single_marketing_plan_cubit.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_form.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_text_field.dart';
import 'package:intheloopapp/ui/marketer/marketing_plan_complete_view.dart';

class CreateSingleMarketingPlanView extends StatelessWidget {
  const CreateSingleMarketingPlanView({super.key});

  Widget get _buildForm => BlocBuilder<CreateSingleMarketingPlanCubit,
          CreateSingleMarketingPlanState>(
        builder: (context, state) {
          final cubit = context.read<CreateSingleMarketingPlanCubit>();
          return switch (state.isSubmitted) {
            false => TappedForm(
                questions: [
                  TappedTextField(
                    key: const Key('aesthetic'),
                    title: 'what is the aesthetic?',
                    initialValue: state.aesthetic.asNullable() ?? '',
                    onChange: cubit.updateAesthetic,
                    examples: const [
                      'dreamy waves',
                      'futuristic cyberpunk',
                      '90s y2k',
                      'rage rap',
                    ],
                  ),
                 TappedTextField(
                    key: const Key('targetAudience'),
                    title: 'do you have a target audience?',
                    initialValue: state.targetAudience.asNullable() ?? '',
                    onChange: cubit.updateTargetAudience,
                    examples: const [],
                  ),
                 TappedTextField(
                    key: const Key('moreToCome'),
                    title: 'is this leading to something bigger?',
                    initialValue: state.moreToCome.asNullable() ?? '',
                    onChange: cubit.updateMoreToCome,
                    examples: const [
                      'an album',
                      'a music video',
                    ],
                  ),
                 TappedTextField(
                    key: const Key('releaseTimeline'),
                    title: 'what is your release timeline?',
                    initialValue: state.releaseTimeline.asNullable() ?? '',
                    onChange: cubit.updateReleaseTimeline,
                    examples: const [
                      'tomorrow',
                      'next week',
                      'next month',
                      'who knows',
                    ],
                  ),
                ],
                onSubmit: () =>
                    context.read<CreateSingleMarketingPlanCubit>().submit(),
              ),
            true => const MarketingPlanCompleteView(),
          };
        },
      );

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CreateSingleMarketingPlanCubit>(
      create: (context) => CreateSingleMarketingPlanCubit(),
      child: _buildForm,
    );
  }
}
