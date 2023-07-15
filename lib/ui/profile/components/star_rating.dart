import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';

class StarRating extends StatelessWidget {
  const StarRating({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final overallRating = switch (state.visitedUser.overallRating) {
          None() => '0.0',
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
      },
    );
  }
}
