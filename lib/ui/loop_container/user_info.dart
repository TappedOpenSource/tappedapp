import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/common/rating_chip.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:timeago/timeago.dart' as timeago;

class UserInfo extends StatelessWidget {
  const UserInfo({
    required this.loopUser,
    required this.timestamp,
    super.key,
  });

  final UserModel loopUser;
  final DateTime timestamp;

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();
    final theme = Theme.of(context);

    return FutureBuilder<bool>(
      future: database.isVerified(loopUser.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final verified = snapshot.data!;
        final overallRatingWidgets = switch (loopUser.overallRating) {
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

        return GestureDetector(
          onTap: () => context.push(
            ProfilePage(
              userId: loopUser.id,
              user: Some(loopUser),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      // + User Avatar
                      UserAvatar(
                        radius: 24,
                        pushUser: Some(loopUser),
                        imageUrl: loopUser.profilePicture,
                        verified: verified,
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 28,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (loopUser.artistName.isNotEmpty)
                        RichText(
                          text: TextSpan(
                            text: loopUser.artistName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                            children: overallRatingWidgets,
                          ),
                        ),
                      Text(
                        '@${loopUser.username}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        timeago.format(
                          timestamp,
                          locale: 'en_short',
                        ),
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              BlocBuilder<AppThemeCubit, bool>(
                builder: (context, isDark) {
                  return Container(
                    height: 25,
                    width: 100,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.fitHeight,
                        image: isDark
                            ? const AssetImage(
                                'assets/tapped_logo_reversed.png',
                              )
                            : const AssetImage(
                                'assets/tapped_logo.png',
                              ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
