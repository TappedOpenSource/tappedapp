import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/user_avatar.dart';

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

                return IconButton(
                  onPressed: isFollowing
                      ? () {}
                      : () async {
                          await database.followUser(
                            currentUser.id,
                            widget.user.id,
                          );
                          setState(() {
                            followingOverride = true;
                          });
                        },
                  icon: isFollowing 
                  ? const Icon(
                    Icons.check_circle,
                  )
                  : const Icon(
                    Icons.add_circle,
                  ),
                );
              },
            )
          : const SizedBox.shrink();

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();
    final imageUrl = widget.user.profilePicture;
    if (widget.user.deleted) return const SizedBox.shrink();

    return BlocSelector<OnboardingBloc, OnboardingState, UserModel?>(
      selector: (state) => (state is Onboarded) ? state.currentUser : null,
      builder: (context, currentUser) {
        if (currentUser == null) {
          return const ListTile(
            leading: UserAvatar(
              radius: 25,
            ),
            title: Text('ERROR'),
            subtitle: Text("something isn't working right :/"),
          );
        }

        return FutureBuilder<bool>(
          future: database.isVerified(widget.user.id),
          builder: (context, snapshot) {
            final verified = snapshot.data ?? false;

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
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: (imageUrl == null || imageUrl.isEmpty)
                              ? const AssetImage('assets/default_avatar.png')
                                  as ImageProvider
                              : CachedNetworkImageProvider(
                                  imageUrl,
                                  errorListener: () {
                                    return;
                                  },
                                ),
                        ),
                      ),
                      child: Padding(
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
                              '${widget.user.followerCount} followers',
                            ),
                            // _followButton(
                            //   currentUser,
                            //   database,
                            // ),
                          ],
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
                ],
              ),
            );
          },
        );
      },
    );
  }
}
