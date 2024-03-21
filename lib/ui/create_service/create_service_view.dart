import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/create_service/components/description_text_field.dart';
import 'package:intheloopapp/ui/create_service/components/edit_service_button.dart';
import 'package:intheloopapp/ui/create_service/components/rate_type_selector.dart';
import 'package:intheloopapp/ui/create_service/components/submit_service_button.dart';
import 'package:intheloopapp/ui/create_service/components/title_text_field.dart';
import 'package:intheloopapp/ui/create_service/create_service_cubit.dart';
import 'package:intheloopapp/ui/forms/rate_text_field.dart';
import 'package:intheloopapp/ui/themes.dart';
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
    final payments = context.payments;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        final ownerId = service.fold(
          () => currentUser.id,
          (value) => value.userId,
        );
        return BlocProvider<CreateServiceCubit>(
          create: (context) => CreateServiceCubit(
            database: database,
            nav: nav,
            ownerId: ownerId,
          )..initFields(service),
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            appBar: AppBar(
              actions: [
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
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const TitleTextField(),
                      const SizedBox(height: 16),
                      const DescriptionTextField(),
                      const SizedBox(height: 36),
                      FutureBuilder<bool>(
                        future: (() async {
                          if (ownerId == currentUser.id) {
                            return currentUser
                                .hasValidConnectedAccount(payments);
                          }

                          final owner = await database.getUserById(ownerId);
                          return owner.fold(
                            () => Future.value(false),
                            (t) => t.hasValidConnectedAccount(payments),
                          );
                        })(),
                        builder: (context, snapshot) {
                          final isValid = snapshot.data;
                          return switch (isValid) {
                            null => const CupertinoActivityIndicator(),
                            false => GestureDetector(
                                onTap: () => context.push(SettingsPage()),
                                child: const Text(
                                  'connect your bank to make this paid',
                                  style: TextStyle(
                                    color: tappedAccent,
                                  ),
                                ),
                              ),
                            true => Column(
                                children: [
                                  BlocBuilder<CreateServiceCubit,
                                      CreateServiceState>(
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
                                ],
                              ),
                          };
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
