import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/utils/admin_builder.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intl/intl.dart';
import 'package:share_plus/share_plus.dart';

class MoreOptionsButton extends StatelessWidget {
  const MoreOptionsButton({super.key});

  void _showActionSheet(
    BuildContext context, {
    required UserModel user,
    required UserModel currentUser,
    required bool isAdmin,
  }) {
    final database = context.database;
    final nav = context.nav;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => FutureBuilder(
        future: database.isVerified(user.id),
        builder: (context, snapshot) {
          final isVerified = snapshot.data ?? false;
          return CupertinoActionSheet(
            title: Text(user.displayName),
            // message: Text(user.username.username),
            actions: <CupertinoActionSheetAction>[
              if (isAdmin && user.id != currentUser.id)
                switch (user.unclaimed) {
                  true => CupertinoActionSheetAction(
                      onPressed: () {},
                      child: const Text('unclaimed account'),
                    ),
                  false => CupertinoActionSheetAction(
                      onPressed: () {
                        // Copy to clipboard
                        Clipboard.setData(
                          ClipboardData(
                            text: user.latestAppVersion.getOrElse(() => ''),
                          ),
                        ).then((value) {
                          Navigator.pop(context);
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: tappedAccent,
                              content: Text(
                                  'latest app version copied to clipboard',),
                            ),
                          );
                        });
                      },
                      child: Text(
                        'latest app version ${user.latestAppVersion.getOrElse(() => 'unknown')}',
                      ),
                    ),
                },
              if (isAdmin)
                switch (user.timestamp) {
                  None() => CupertinoActionSheetAction(
                      onPressed: () {},
                      child: const Text('joined unknown'),
                    ),
                  Some(:final value) => CupertinoActionSheetAction(
                      onPressed: () {},
                      child: Text('joined ${dateFormat.format(value)}'),
                    ),
                },
              if (isAdmin)
                CupertinoActionSheetAction(
                  onPressed: () {
                    // Copy to clipboard
                    Clipboard.setData(
                      ClipboardData(text: user.id),
                    ).then((value) {
                      Navigator.pop(context);
                      scaffoldMessenger.showSnackBar(
                        const SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: tappedAccent,
                          content: Text('id copied to clipboard'),
                        ),
                      );
                    });
                  },
                  child: Text('userId ${user.id}'),
                ),
              if (isAdmin)
                switch (isVerified) {
                  true => CupertinoActionSheetAction(
                      onPressed: () {},
                      child: const Text('✅ verified'),
                    ),
                  false => CupertinoActionSheetAction(
                      onPressed: () {
                        database.verifyUser(user.id).then((value) {
                          scaffoldMessenger.showSnackBar(
                            const SnackBar(
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: tappedAccent,
                              content: Text('user verified'),
                            ),
                          );
                        });
                      },
                      child: Text('verify ${user.username}'),
                    ),
                },
              CupertinoActionSheetAction(
                onPressed: () {
                  FirebaseAnalytics.instance.logEvent(
                    name: 'share_profile',
                    parameters: {
                      'user_id': user.id,
                      'type': 'link',
                      'from': 'profile_page',
                    },
                  );

                  Share.share('https://tapped.ai/${user.username}')
                      .onError((error, stackTrace) {
                    logger.error(
                      'Error sharing profile',
                      error: error,
                      stackTrace: stackTrace,
                    );
                    scaffoldMessenger.showSnackBar(
                      const SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        content: Text('Error sharing profile'),
                      ),
                    );
                  });
                },
                child: const Text('share profile'),
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
                      scaffoldMessenger.showSnackBar(
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
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return AdminBuilder(
          builder: (context, isAdmin) {
            return IconButton(
              onPressed: () => _showActionSheet(
                context,
                user: state.visitedUser,
                currentUser: state.currentUser,
                isAdmin: isAdmin,
              ),
              icon: Icon(
                CupertinoIcons.ellipsis,
                color: theme.colorScheme.onSurface,
              ),
            );
          },
        );
      },
    );
  }
}
