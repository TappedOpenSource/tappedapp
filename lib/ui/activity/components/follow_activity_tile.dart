import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/activity_bloc/activity_bloc.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:timeago/timeago.dart' as timeago;

class FollowActivityTile extends StatelessWidget {
  const FollowActivityTile({
    required this.activity,
    super.key,
  });

  final Follow activity;

  void onClick(BuildContext context, Option<UserModel> fromUser) {
    context.push(
      ProfilePage(
        userId: activity.fromUserId,
        user: fromUser,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final databaseRepository = context.database;

    var markedRead = activity.markedRead;

    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return FutureBuilder<Option<UserModel>>(
          future: databaseRepository.getUserById(
            activity.fromUserId,
          ),
          builder: (context, snapshot) {
            final user = snapshot.data;
            return switch (user) {
              null => const SizedBox.shrink(),
              None() => const SizedBox.shrink(),
              Some(:final value) => () {
                  if (value.deleted) {
                    return const SizedBox.shrink();
                  }

                  if (!markedRead) {
                    context
                        .read<ActivityBloc>()
                        .add(MarkActivityAsReadEvent(activity: activity));
                    markedRead = true;
                  }

                  return FutureBuilder<bool>(
                    future: databaseRepository.isVerified(value.id),
                    builder: (context, snapshot) {
                      final isVerified = snapshot.data ?? false;

                      return Column(
                        children: [
                          GestureDetector(
                            onTap: () => onClick(
                              context,
                              user,
                            ),
                            child: ListTile(
                              tileColor: markedRead ? null : Colors.grey[900],
                              leading: UserAvatar(
                                radius: 20,
                                pushUser: user,
                                imageUrl: value.profilePicture,
                                verified: isVerified,
                              ),
                              trailing: Text(
                                timeago.format(
                                  activity.timestamp,
                                  locale: 'en_short',
                                ),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight:
                                      markedRead ? null : FontWeight.bold,
                                ),
                              ),
                              title: Text(
                                value.displayName,
                                style: TextStyle(
                                  fontWeight:
                                      markedRead ? null : FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                'followed you 🤝',
                                style: TextStyle(
                                  fontWeight:
                                      markedRead ? null : FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }(),
            };
          },
        );
      },
    );
  }
}
