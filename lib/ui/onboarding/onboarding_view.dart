import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/error/error_view.dart';
import 'package:intheloopapp/ui/onboarding/components/onboarding_form.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_flow_cubit.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class OnboardingView extends StatelessWidget {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          logger.info('user is authenticated');
        }

        final user = switch (state) {
          Authenticated(:final currentAuthUser) => Some(currentAuthUser),
          Unauthenticated() => const None<User>(),
          Uninitialized() => const None<User>(),
        };

        return switch (user) {
          None() => const ErrorView(),
          Some(:final value) => BlocProvider(
              create: (context) => OnboardingFlowCubit(
                currentAuthUser: value,
                onboardingBloc: context.onboarding,
                navigationBloc: context.nav,
                authenticationBloc: context.authentication,
                storageRepository: context.storage,
                databaseRepository: context.database,
              ),
              // ..initFollowRecommendations(),
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                // appBar: const TappedAppBar(
                //   title: 'Onboarding',
                // ),
                // floatingActionButton: const ControlButtons(),
                body: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: const OnboardingForm(),
                ),
              ),
            ),
        };
      },
    );
  }
}
