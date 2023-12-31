import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/follow_relationship/follow_relationship_cubit.dart';
import 'package:intheloopapp/ui/user_tile.dart';

class FollowerTab extends StatelessWidget {
  const FollowerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FollowRelationshipCubit, FollowRelationshipState>(
      builder: (context, state) {
        return Center(
          child: RefreshIndicator(
            onRefresh: () =>
                context.read<FollowRelationshipCubit>().initFollowers(),
            child: state.followers.isEmpty
                // TODO(jonaylor89): Put in something with an action - perhaps a call to upload more loops?, https://github.com/InTheLoopStudio/pangolin/issues/51
                ? const Text('No Followers')
                : ListView.builder(
                    itemCount: state.followers.length,
                    itemBuilder: (BuildContext context, int index) {
                      final user = state.followers[index];
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
