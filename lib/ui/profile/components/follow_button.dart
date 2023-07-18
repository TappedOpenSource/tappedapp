import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.currentUser.id != state.visitedUser.id) {
          return CupertinoButton(
            onPressed: () => context.read<ProfileCubit>()
              ..toggleFollow(state.currentUser.id, state.visitedUser.id),
            color: state.isFollowing
                ? tappedAccent
                : Colors.white.withOpacity(0.1),
            padding: const EdgeInsets.all(12),
            child: Text(
              state.isFollowing ? 'Following' : 'Follow',
              style: TextStyle(
                fontSize: 17,
                color: state.isFollowing ? Colors.green : Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }

        return CupertinoButton(
          onPressed: () => context.push(SettingsPage()),
          color: theme.colorScheme.onSurface.withOpacity(0.1),
          child: Text(
            'Edit Profile',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }
}
