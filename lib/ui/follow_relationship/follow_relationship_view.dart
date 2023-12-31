import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/follow_relationship/components/follower_tab.dart';
import 'package:intheloopapp/ui/follow_relationship/components/following_tab.dart';
import 'package:intheloopapp/ui/follow_relationship/follow_relationship_cubit.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/themes.dart';

class FollowRelationshipView extends StatelessWidget {
  const FollowRelationshipView({
    required this.visitedUserId,
    super.key,
    this.initialIndex,
  });

  final String visitedUserId;
  final int? initialIndex;

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    final theme = Theme.of(context);

    return FutureBuilder<Option<UserModel>>(
      future: databaseRepository.getUserById(visitedUserId),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const LoadingView();
        }

        final user = snapshot.data;

        return switch (user) {
          null => const LoadingView(),
          None() => const LoadingView(),
          Some(:final value) => BlocProvider(
              create: (context) => FollowRelationshipCubit(
                databaseRepository: databaseRepository,
                visitedUserId: visitedUserId,
              )
                ..initFollowers()
                ..initFollowing(),
              child: DefaultTabController(
                initialIndex: initialIndex ?? 0,
                length: 2,
                child: Scaffold(
                  backgroundColor: theme.colorScheme.background,
                  appBar: AppBar(
                    backgroundColor: theme.colorScheme.background,
                    bottom: const TabBar(
                      indicatorColor: tappedAccent,
                      labelColor: tappedAccent,
                      tabs: [
                        Tab(
                          child: Text('Followers'),
                        ),
                        Tab(
                          child: Text('Following'),
                        ),
                      ],
                    ),
                    title: Row(
                      children: [
                        Text(
                          value.displayName,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: const TabBarView(
                    children: [
                      FollowerTab(),
                      FollowingTab(),
                    ],
                  ),
                ),
              ),
            ),
        };
      },
    );
  }
}
