import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/error/error_view.dart';
import 'package:intheloopapp/ui/shell/components/bottom_toolbar.dart';

class ShellView extends StatelessWidget {
  const ShellView({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<OnboardingBloc, OnboardingState, Option<UserModel>>(
      selector: (state) =>
          (state is Onboarded) ? Some(state.currentUser) : const None(),
      builder: (context, currentUser) {
        return switch (currentUser) {
          None() => const ErrorView(),
          Some(:final value) => BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                return Scaffold(
                  body: child,
                  bottomNavigationBar: BottomToolbar(
                    user: value,
                  ),
                );
              },
            ),
        };
      },
    );
  }
}
