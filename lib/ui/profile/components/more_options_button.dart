import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/deep_link_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:share_plus/share_plus.dart';

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key});

  void _showActionSheet(
    BuildContext context,
    UserModel user,
    UserModel currentUser,
  ) {
    final dynamic = context.read<DeepLinkRepository>();
    final database = context.database;
    final nav = context.nav;
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: Text(user.displayName),
        // message: Text(user.username.username),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              final link = 'https://tapped.ai/${user.username}';
              Share.share(link);
            },
            child: const Text('share performer profile'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              final link = 'https://tapped.ai/b/${user.username}';
              Share.share(link);
            },
            child: const Text('share booker profile'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              dynamic
                  .getShareProfileDeepLink(user)
                  .then(Share.share)
                  .onError((error, stackTrace) {
                logger.error(
                  'Error sharing profile',
                  error: error,
                  stackTrace: stackTrace,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.red,
                    content: Text('Error sharing profile'),
                  ),
                );
              });
            },
            child: const Text('share deep link'),
          ),
          if (user.id != currentUser.id)
            CupertinoActionSheetAction(
              onPressed: () {
                nav.pop();
                database
                    .reportUser(
                  reported: user,
                  reporter: currentUser,
                )
                    .then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: tappedAccent,
                      content: Text('User Reported'),
                    ),
                  );
                });
              },
              child: const Text('report user'),
            ),
          if (user.id != currentUser.id)
            CupertinoActionSheetAction(
              /// This parameter indicates the action would perform
              /// a destructive action such as delete or exit and turns
              /// the action's text color to red.
              isDestructiveAction: true,
              onPressed: () {
                nav.pop();
                context.read<ProfileCubit>().block().then((value) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                      content: Text('User Blocked'),
                    ),
                  );
                });
              },
              child: const Text('block user'),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return IconButton(
          onPressed: () => _showActionSheet(
            context,
            state.visitedUser,
            state.currentUser,
          ),
          icon: Icon(
            CupertinoIcons.ellipsis,
            color: theme.colorScheme.onSurface,
          ),
        );
      },
    );
  }
}
