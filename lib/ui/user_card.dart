import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final imageUrl = user.profilePicture.toNullable();
    if (user.deleted) return const SizedBox.shrink();

    final audienceText = '${NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
    ).format(user.socialFollowing.audienceSize)} followers';

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
          future: database.isVerified(user.id),
          builder: (context, snapshot) {
            final verified = snapshot.data ?? false;
            final provider = (imageUrl == null || imageUrl.isEmpty)
                ? const AssetImage('assets/default_avatar.png') as ImageProvider
                : CachedNetworkImageProvider(
                    imageUrl,
                  );
            final uuid = const Uuid().v4();
            final heroImageTag = 'user-image-${user.id}-$uuid';
            final heroTitleTag = 'user-title-${user.id}-$uuid';
            return SizedBox(
              width: 150,
              height: 150,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  GestureDetector(
                    onTap: () => context.push(
                      ProfilePage(
                        userId: user.id,
                        user: Option.of(user),
                        heroImage: HeroImage(
                          imageProvider: provider,
                          heroTag: heroImageTag,
                        ),
                        titleHeroTag: heroTitleTag,
                      ),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Hero(
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
                            //   pushUser: Option.of(widget.user),
                            //   imageUrl: widget.user.profilePicture,
                            //   verified: verified,
                            // ),
                          ),
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
                                  text: user.displayName,
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
                              if (user.socialFollowing.audienceSize != 0)
                                Text(
                                  audienceText,
                                  style: const TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                            ],
                          ),
                        ),
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
