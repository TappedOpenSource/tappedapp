import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/ui/common/tapped_app_bar.dart';
import 'package:intheloopapp/ui/create_service/components/description_text_field.dart';
import 'package:intheloopapp/ui/create_service/components/edit_service_button.dart';
import 'package:intheloopapp/ui/create_service/components/rate_type_selector.dart';
import 'package:intheloopapp/ui/create_service/components/submit_service_button.dart';
import 'package:intheloopapp/ui/create_service/components/title_text_field.dart';
import 'package:intheloopapp/ui/create_service/create_service_cubit.dart';
import 'package:intheloopapp/ui/forms/rate_text_field.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class CreateServiceView extends StatelessWidget {
  const CreateServiceView({
    required this.service,
    required this.onSubmit,
    super.key,
  });

  final Option<Service> service;
  final void Function(Service) onSubmit;

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final nav = context.nav;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocProvider<CreateServiceCubit>(
          create: (context) => CreateServiceCubit(
            database: database,
            nav: nav,
            currentUserId: currentUser.id,
          )..initFields(service),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: const TappedAppBar(
              title: 'Create Service',
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 32,
                  horizontal: 32,
                ),
                child: Column(
                  children: [
                    const TitleTextField(),
                    const SizedBox(height: 16),
                    const DescriptionTextField(),
                    const SizedBox(height: 16),
                    BlocBuilder<CreateServiceCubit, CreateServiceState>(
                      builder: (context, state) {
                        return RateTextField(
                          initialValue: state.rate,
                          onChanged: (input) => context
                              .read<CreateServiceCubit>()
                              .onRateChange(input),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const RateTypeSelector(),
                    const SizedBox(height: 16),
                    switch (service) {
                      None() => SubmitServiceButton(
                          onCreated: onSubmit,
                        ),
                      Some(:final value) => EditServiceButton(
                          onEdited: onSubmit,
                          service: value,
                        ),
                    },
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
