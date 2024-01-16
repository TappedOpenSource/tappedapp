import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/follow_relationship/follow_relationship_cubit.dart';
import 'package:intheloopapp/ui/user_tile.dart';

class FollowingTab extends StatelessWidget {
  const FollowingTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowRelationshipCubit, FollowRelationshipState>(
      builder: (context, state) {
        return Center(
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<FollowRelationshipCubit>().initFollowing(),
            child: state.following.isEmpty
                // TODO(jonaylor): Replace with follow recommendations, https://github.com/TappedOpenSource/pangolin/issues/50
                ? const Text('No Following')
                : ListView.builder(
                    itemCount: state.following.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = state.following[index];
                      return UserTile(
                        userId: user.id,
                        user: Some(user),
                      );
                    },
                  ),
          ),
        );
      },
    );
  }
}
