import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/user_avatar.dart';

class CommonFollowersSliver extends StatelessWidget {
  const CommonFollowersSliver({super.key});

  Widget _displayCommonFollowers(
    BuildContext context,
    UserModel currentUser,
    UserModel visitedUser,
  ) {
    final database = context.read<DatabaseRepository>();
    return FutureBuilder(
      future: database.getCommonFollowers(
        currentUser.id,
        visitedUser.id,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox.shrink();
          //return CircularProgressIndicator();
        } else {
          final feaUsers = snapshot.data ?? [];
          return listIntersections(context, feaUsers);
        }
      },
    );
  }

  Widget _userAvatar(BuildContext context, UserModel user) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(17),
      ),
      child: UserAvatar(
        radius: 14,
        pushUser: Some(user),
        imageUrl: user.profilePicture,
      ),
    );
  }

  Widget listIntersections(BuildContext context, List<UserModel> intersects) {
    return switch (intersects.length) {
      > 3 => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Followed by: '),
            for (int i = 0; i < 3; i++)
              Padding(
                padding: EdgeInsets.only(left: i * 20),
                child: _userAvatar(context, intersects[i]),
              ),
            Text('and ${intersects.length - 3} others'),
          ],
        ),
      > 0 => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Followed by: '),
            for (int i = 0; i < intersects.length; i++)
              Padding(
                padding: EdgeInsets.only(left: i * 20),
                child: _userAvatar(context, intersects[i]),
              ),
          ],
        ),
      _ => const SizedBox.shrink(),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return _displayCommonFollowers(
          context,
          state.currentUser,
          state.visitedUser,
        );
      },
    );
  }
}
