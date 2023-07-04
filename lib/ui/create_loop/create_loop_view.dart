import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/audio_repository.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/storage_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/create_loop/components/attachments.dart';
import 'package:intheloopapp/ui/create_loop/components/loop_description_text_field.dart';
import 'package:intheloopapp/ui/create_loop/components/loop_title_text_field.dart';
import 'package:intheloopapp/ui/create_loop/components/opportunity_toggle.dart';
import 'package:intheloopapp/ui/create_loop/components/submit_loop_button.dart';
import 'package:intheloopapp/ui/create_loop/cubit/create_loop_cubit.dart';
import 'package:intheloopapp/ui/error/error_view.dart';
import 'package:intheloopapp/ui/user_avatar.dart';

class CreateLoopView extends StatelessWidget {
  const CreateLoopView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const ErrorView();
        }

        return BlocProvider(
          create: (context) => CreateLoopCubit(
            currentUser: currentUser,
            audioRepo: context.read<AudioRepository>(),
            onboardingBloc: context.read<OnboardingBloc>(),
            databaseRepository: context.read<DatabaseRepository>(),
            storageRepository: context.read<StorageRepository>(),
            navigationBloc: context.read<NavigationBloc>(),
          ),
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Create Loop',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      height: 30,
                      width: 30,
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .bottomNavigationBarTheme
                            .unselectedItemColor,
                        borderRadius: BorderRadius.circular(30.0 / 2),
                      ),
                      child: UserAvatar(
                        radius: 45,
                        pushUser: Some(currentUser),
                        imageUrl: currentUser.profilePicture,
                      ),
                    ),
                  ],
                ),
              ),
              body: const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 40,
                ),
                child: Column(
                  children: [
                    LoopTitleTextField(),
                    SizedBox(
                      height: 24,
                    ),
                    LoopDescriptionTextField(),
                    SizedBox(
                      height: 24,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OpportunityToggle(),
                      ],
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Attachments(),
                  ],
                ),
              ),
              floatingActionButton: const SubmitLoopButton(),
            ),
          ),
        );
      },
    );
  }
}