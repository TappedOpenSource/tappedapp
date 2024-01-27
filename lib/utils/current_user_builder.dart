import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/error/error_view.dart';

class CurrentUserBuilder extends StatelessWidget {
  const CurrentUserBuilder({
    required this.builder,
    this.errorWidget,
    super.key,
  });

  final Widget Function(BuildContext, UserModel) builder;
  final Widget? errorWidget;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Option<UserModel>>(
      selector: (state) =>
          state is Onboarded ? Option.of(state.currentUser) : const None(),
      builder: (context, currentUser) {
        return switch (currentUser) {
          None() => errorWidget ?? const ErrorView(),
          Some(:final value) => builder(context, value),
        };
      },
    );
  }
}
