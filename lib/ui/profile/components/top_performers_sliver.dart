import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/discover/components/user_slider.dart';
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
              child: FutureBuilder(
                future: (() async {
                  final performers = (await Future.wait(
                    topPerformerIds.map(database.getUserById),
                  ))
                      .whereType<Some<UserModel>>()
                      .map((e) => e.value)
                      .toList();

                  return performers;
                })(),
                builder: (context, snapshot) {
                  final performers = snapshot.data ?? [];
                  return UserSlider(
                    users: performers,
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
