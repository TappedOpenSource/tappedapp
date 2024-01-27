import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key});

  Widget _ratingWidget(Option<double> rating) {
    final overallRating = switch (rating) {
      None() => 'N/A',
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
        const Text('Rating'),
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
