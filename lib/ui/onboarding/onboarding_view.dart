import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/authentication_bloc/authentication_bloc.dart';
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
          logger.warning('user is not authenticated');
        }

        final user = switch (state) {
          Authenticated(:final currentAuthUser) => Option.of(currentAuthUser),
          Unauthenticated() => const None(),
          Uninitialized() => const None(),
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
              child: const OnboardingForm(),
            ),
        };
      },
    );
  }
}
