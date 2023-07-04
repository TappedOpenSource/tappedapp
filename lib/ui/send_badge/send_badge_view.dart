import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/error/error_view.dart';
import 'package:intheloopapp/ui/send_badge/components/badge_description_text_field.dart';
import 'package:intheloopapp/ui/send_badge/components/badge_image_input.dart';
import 'package:intheloopapp/ui/send_badge/components/badge_name_text_field.dart';
import 'package:intheloopapp/ui/send_badge/components/badge_receiver_text_field.dart';
import 'package:intheloopapp/ui/send_badge/send_badge_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';

/// The screen for sending a badge
class SendBadgeView extends StatelessWidget {
  ///
  const SendBadgeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const ErrorView();
        }

        return BlocProvider(
          create: (context) => SendBadgeCubit(
            currentUser: currentUser,
            navigationBloc: context.read<NavigationBloc>(),
            databaseRepository: context.read<DatabaseRepository>(),
            storageRepository: context.read<StorageRepository>(),
          ),
          child: BlocBuilder<SendBadgeCubit, SendBadgeState>(
            builder: (context, state) {
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  title: const Text('Send Badge'),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Form(
                    key: state.formKey,
                    child: ListView(
                      children: [
                        const SizedBox(height: 50),
                        const BadgeImageInput(),
                        const SizedBox(height: 50),
                        BadgeReceiverTextField(
                          onChanged: (input) => context
                              .read<SendBadgeCubit>()
                              .changeReceiverUsername(input),
                          initialValue: '',
                        ),
                        const SizedBox(height: 50),
                        BadgeNameTextField(
                          onChanged: (input) => context
                              .read<SendBadgeCubit>()
                              .changeBadgeName(input),
                          initialValue: '',
                        ),
                        const SizedBox(height: 50),
                        BadgeDescriptionTextField(
                          onChanged: (input) => context
                              .read<SendBadgeCubit>()
                              .changeBadgeDescription(input),
                          initialValue: '',
                        ),
                        const SizedBox(height: 50),
                        MaterialButton(
                          color: tappedAccent,
                          onPressed: context.read<SendBadgeCubit>().sendBadge,
                          child: const Text('Send'),
                        ),
                        if (state.status.isInProgress)
                          const CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(tappedAccent),
                          )
                        else
                          const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}