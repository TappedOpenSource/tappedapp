import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/user_card.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class TopPerformersSliver extends StatelessWidget {
  const TopPerformersSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final topPerformerIds = state.visitedUser.venueInfo.fold(
          () => <String>[],
          (t) => t.topPerformerIds,
        );

        if (topPerformerIds.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 8,
              ),
              child: Text(
                'top performers',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: topPerformerIds.length,
                itemBuilder: (context, index) {
                  final userId = topPerformerIds[index];
                  return FutureBuilder(
                    future: database.getUserById(userId),
                    builder: (context, snapshot) {
                      final user = snapshot.data;
                      return switch (user) {
                        null => const SizedBox.shrink(),
                        None() => const SizedBox.shrink(),
                        Some(:final value) => Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: UserCard(
                              user: value,
                            ),
                          ),
                      };
                    },
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
