import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/common/rating_chip.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';

class UserTile extends StatefulWidget {
  const UserTile({
    required this.userId,
    required this.user,
    this.showFollowButton = true,
    this.subtitle,
    this.trailing,
    super.key,
  });

  final String userId;
  final Option<UserModel> user;
  final bool showFollowButton;
  final Widget? subtitle;
  final Widget? trailing;

  @override
  State<UserTile> createState() => _UserTileState();
}

class _UserTileState extends State<UserTile> {
  bool followingOverride = false;

  Widget _buildSubtitle(
    UserModel user,
  ) {
    final widgetSubtitle = widget.subtitle;
    if (widgetSubtitle != null) return widgetSubtitle;

    return Text('${NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
    ).format(user.socialFollowing.audienceSize)} followers');
  }

  Widget _buildUserTile(
    BuildContext context,
    UserModel user,
  ) {
    if (user.deleted) return const SizedBox.shrink();

    final database = context.database;

    return CurrentUserBuilder(
      errorWidget: const ListTile(
        leading: UserAvatar(
          radius: 25,
        ),
        title: Text('ERROR'),
        subtitle: Text("something isn't working right :/"),
      ),
      builder: (context, currentUser) {
        return FutureBuilder<bool>(
          future: database.isVerified(widget.userId),
          builder: (context, snapshot) {
            final verified = snapshot.data ?? false;
            final overallRatingWidgets = switch (user.overallRating) {
              None() => [
                  const WidgetSpan(
                    child: SizedBox.shrink(),
                  ),
                ],
              Some(:final value) => [
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: RatingChip(
                      rating: value,
                    ),
                  ),
                ],
            };

            return ListTile(
              leading: UserAvatar(
                radius: 25,
                pushUser: Option.of(user),
                imageUrl: user.profilePicture.toNullable(),
                verified: verified,
              ),
              title: RichText(
                maxLines: 2,
                overflow: TextOverflow.fade,
                text: TextSpan(
                  text: user.displayName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  children: [
                    ...overallRatingWidgets,
                  ],
                ),
              ),
              subtitle: _buildSubtitle(user),
              trailing: widget.trailing,
              onTap: () => context.push(
                ProfilePage(
                  userId: user.id,
                  user: Option.of(
                    user,
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return switch (widget.user) {
      None() => () {
          return FutureBuilder<Option<UserModel>>(
            future: database.getUserById(widget.userId),
            builder: (context, snapshot) {
              final data = snapshot.data;
              return switch (data) {
                null => SkeletonListTile(),
                None() => SkeletonListTile(),
                Some(:final value) => _buildUserTile(context, value),
              };
            },
          );
        }(),
      Some(:final value) => _buildUserTile(context, value),
    };
  }
}
