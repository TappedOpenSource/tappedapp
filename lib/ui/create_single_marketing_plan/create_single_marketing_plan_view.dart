import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/create_single_marketing_plan/cubit/create_single_marketing_plan_cubit.dart';
import 'package:intheloopapp/ui/forms/aesthetic_form_field.dart';
import 'package:intheloopapp/ui/forms/more_to_come_form_field.dart';
import 'package:intheloopapp/ui/forms/release_timeline_form_field.dart';
import 'package:intheloopapp/ui/forms/tapped_form/tapped_form.dart';
import 'package:intheloopapp/ui/forms/target_audience_form_field.dart';
import 'package:intheloopapp/ui/marketer/marketing_plan_complete_view.dart';

class CreateSingleMarketingPlanView extends StatelessWidget {
  const CreateSingleMarketingPlanView({super.key});

  Widget get _buildForm => BlocBuilder<CreateSingleMarketingPlanCubit,
          CreateSingleMarketingPlanState>(
        builder: (context, state) {
          return switch (state.isSubmitted) {
            false => TappedForm(
                questions: const [
                  AestheticFormField(),
                  TargetAudienceFormField(),
                  MoreToComeFormField(),
                  ReleaseTimelineFormField(),
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
