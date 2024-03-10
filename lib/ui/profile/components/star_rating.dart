import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key});

  Widget _ratingWidget(Option<double> rating) {
    final overallRating = switch (rating) {
      None() => 'n/a',
      Some(:final value) => value.toStringAsFixed(1),
    };
    return Column(
      children: [
        Text(
          overallRating,
          style: const TextStyle(
            fontSize: 24,
          ),
        ),
        const Text('rating'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return _ratingWidget(state.visitedUser.overallRating);
      },
    );
  }
}
