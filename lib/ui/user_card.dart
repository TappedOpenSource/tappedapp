import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class UserCard extends StatefulWidget {
  const UserCard({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool followingOverride = false;

  Widget _followButton(
    UserModel currentUser,
    DatabaseRepository database,
  ) =>
      currentUser.id != widget.user.id
          ? FutureBuilder<bool>(
              future: database.isFollowingUser(
                currentUser.id,
                widget.user.id,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox.shrink();
                final isFollowing = snapshot.data ?? false;

                if (followingOverride) {
                  return IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                  );
                }

                if (isFollowing) {
                  return IconButton(
                    onPressed: () async {
                      await database.unfollowUser(
                        currentUser.id,
                        widget.user.id,
                      );
                      setState(() {
                        followingOverride = true;
                      });
                    },
                    icon: const Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                  );
                }

                return IconButton(
                  onPressed: () async {
                    await database.followUser(
                      currentUser.id,
                      widget.user.id,
                    );
                    setState(() {
                      followingOverride = true;
                    });
                  },
                  icon: const Icon(
                    Icons.add_circle,
                    color: Colors.white,
                  ),
                );
              },
            )
          : const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final imageUrl = widget.user.profilePicture;
    if (widget.user.deleted) return const SizedBox.shrink();

    final audienceText =
        widget.user.socialMediaAudience > widget.user.followerCount
            ? '${NumberFormat.compactCurrency(
                decimalDigits: 0,
                symbol: '',
              ).format(widget.user.socialMediaAudience)} audience'
            : '${NumberFormat.compactCurrency(
                decimalDigits: 0,
                symbol: '',
              ).format(widget.user.followerCount)} followers';

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
          future: database.isVerified(widget.user.id),
          builder: (context, snapshot) {
            final verified = snapshot.data ?? false;
            final provider = (imageUrl == null || imageUrl.isEmpty)
                ? const AssetImage('assets/default_avatar.png') as ImageProvider
                : CachedNetworkImageProvider(
                    imageUrl,
                  );
            final uuid = const Uuid().v4();
            final heroImageTag = 'user-image-${widget.user.id}-$uuid';
            final heroTitleTag = 'user-title-${widget.user.id}-$uuid';
            return SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: () => context.push(
                      ProfilePage(
                        userId: widget.user.id,
                        user: Some(
                          widget.user,
                        ),
                        heroImage: HeroImage(
                          imageProvider: provider,
                          heroTag: heroImageTag,
                        ),
                        titleHeroTag: heroTitleTag,
                      ),
                    ),
                    child: Hero(
                      tag: heroImageTag,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: provider,
                          ),
                        ),
                        // leading: UserAvatar(
                        //   radius: 25,
                        //   pushUser: Some(widget.user),
                        //   imageUrl: widget.user.profilePicture,
                        //   verified: verified,
                        // ),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      _followButton(
                        currentUser,
                        database,
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            text: widget.user.displayName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            children: [
                              if (verified)
                                const WidgetSpan(
                                  child: Padding(
                                    padding: EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Text(
                          audienceText,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        // _followButton(
                        //   currentUser,
                        //   database,
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
