import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intl/intl.dart';

class FollowerCount extends StatelessWidget {
  const FollowerCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.visitedUser.socialMediaAudience >
            state.visitedUser.followerCount) {
          return GestureDetector(
            onTap: () {
              context.push(
                FollowRelationshipPage(
                  userId: state.visitedUser.id,
                  index: 0,
                ),
              );
            },
            child: Column(
              children: [
                Text(
                  NumberFormat.compactCurrency(
                    decimalDigits: 0,
                    symbol: '',
                  ).format(state.visitedUser.socialMediaAudience),
                  style: const TextStyle(
                    fontSize: 24,
                  ),
                ),
                const Text(
                  'Audience',
                ),
              ],
            ),
          );
        }

        return GestureDetector(
          onTap: () {
            context.push(
              FollowRelationshipPage(
                userId: state.visitedUser.id,
                index: 0,
              ),
            );
          },
          child: Column(
            children: [
              Text(
                NumberFormat.compactCurrency(
                  decimalDigits: 0,
                  symbol: '',
                ).format(state.visitedUser.followerCount),
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              Text(
                state.visitedUser.followerCount == 1 ? 'Follower' : 'Followers',
              ),
            ],
          ),
        );
      },
    );
  }
}
