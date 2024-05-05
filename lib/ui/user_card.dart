import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/profile/profile_view.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/default_image.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    required this.user,
    this.blur = false,
    this.onTap,
    super.key,
  });

  final UserModel user;
  final bool blur;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final imageUrl = user.profilePicture.toNullable();
    if (user.deleted) return const SizedBox.shrink();

    // final audienceText = '${NumberFormat.compactCurrency(
    //   decimalDigits: 0,
    //   symbol: '',
    // ).format(user.socialFollowing.audienceSize)} followers';
    final category = user.performerInfo.map((t) => t.category);

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
                ? getDefaultImage(Option.of(user.id))
                : CachedNetworkImageProvider(
                    imageUrl,
                  );
            final uuid = const Uuid().v4();
            final heroImageTag = 'user-image-${user.id}-$uuid';
            final heroTitleTag = 'user-title-${user.id}-$uuid';
            return SizedBox(
              width: 150,
              height: 150,
              child: ConditionalParentWidget(
                condition: blur,
                conditionalBuilder: ({required child}) => ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: ImageFiltered(
                    imageFilter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: child,
                  ),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (onTap != null) {
                          onTap?.call();
                          return;
                        }

                        showCupertinoModalBottomSheet<void>(
                          context: context,
                          builder: (context) {
                            return ProfileView(
                              visitedUserId: user.id,
                              visitedUser: Option.of(user),
                              heroImage: HeroImage(
                                imageProvider: provider,
                                heroTag: heroImageTag,
                              ),
                              titleHeroTag: heroTitleTag,
                            );
                          },
                        );

                        // context.push(
                        //   ProfilePage(
                        //     userId: user.id,
                        //     user: Option.of(user),
                        //     heroImage: HeroImage(
                        //       imageProvider: provider,
                        //       heroTag: heroImageTag,
                        //     ),
                        //     titleHeroTag: heroTitleTag,
                        //   ),
                        // );
                      },
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
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  category.fold(
                                    () => Colors.black,
                                    (t) => t.color,
                                  ),
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
                                switch (category) {
                                  Some(:final value) => Text(
                                      value.formattedName.toLowerCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  None() => const SizedBox.shrink(),
                                },
                                // if (user.socialFollowing.audienceSize != 0)
                                //   Text(
                                //     audienceText,
                                //     style: const TextStyle(
                                //       color: Colors.white,
                                //     ),
                                //   ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
