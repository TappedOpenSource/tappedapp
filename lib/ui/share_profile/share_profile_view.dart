import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fpdart/fpdart.dart' hide State;
import 'package:google_fonts/google_fonts.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/default_image.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intl/intl.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

class ShareProfileView extends StatefulWidget {
  const ShareProfileView({
    required this.userId,
    required this.user,
    super.key,
  });

  final String userId;
  final Option<UserModel> user;

  @override
  State<ShareProfileView> createState() => _ShareProfileViewState();
}

class _ShareProfileViewState extends State<ShareProfileView> {
  final _screenshotController = ScreenshotController();
  var _shareLoading = false;

  Future<void> _shareWidgetAsImage() async {
    if (_shareLoading) {
      return;
    }

    setState(() {
      _shareLoading = true;
    });
    try {
      final image = await _screenshotController.capture();
      if (image == null) {
        logger.debug('image is null');
        return null;
      }

      await Share.shareXFiles([
        XFile.fromData(
          image,
          name: 'tapped_profile.png',
          mimeType: 'image/png',
        ),
      ]);
    } catch (e, a) {
      logger.e('error sharing image', error: e, stackTrace: a);
    } finally {
      setState(() {
        _shareLoading = false;
      });
    }
  }

  Widget _buildProfileCard(
    BuildContext context, {
    required UserModel user,
  }) {
    final theme = Theme.of(context);
    const borderRadius = 25.0;
    final bookingCount = user.performerInfo.map((t) => t.bookingCount);
    final reviewCount = user.performerInfo.map((t) => t.reviewCount);
    final audience = user.socialFollowing.audienceSize;
    final rating = user.performerInfo.flatMap((t) => t.rating);
    final socialFollowing = user.socialFollowing;
    final numberFormat = NumberFormat.compact();
    final category = user.performerInfo.map((t) => t.category);
    return Screenshot(
      controller: _screenshotController,
      child: Container(
        width: 450,
        height: 600,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          // gradient: LinearGradient(
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          //   colors: [
          //     theme.colorScheme.primary,
          //   ],
          // ),
          // borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: theme.colorScheme.onSurface.withOpacity(0.1),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: user.profilePicture.fold(
                        () => getDefaultImage(Option.of(user.id)),
                        CachedNetworkImageProvider.new,
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Image.asset(
                    'assets/icon_1024.png',
                    height: 22,
                    width: 22,
                  ),
                ),
                Positioned(
                  left: 6,
                  bottom: 6,
                  child: Text(
                    user.displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.manrope(
                      fontSize: switch (user.displayName.length) {
                        < 12 => 36,
                        < 20 => 32,
                        < 30 => 28,
                        _ => 24,
                      },
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  switch (category) {
                    None() => const SizedBox.shrink(),
                    Some(:final value) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            value.formattedName.toLowerCase(),
                            style: TextStyle(
                              fontSize: 18,
                              color: value.color,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'performer',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                  },
                  switch (reviewCount) {
                    None() => const SizedBox.shrink(),
                    Some(:final value) => Column(
                        children: [
                          Text(
                            value.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'reviews',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                  },
                  switch (rating) {
                    None() => const SizedBox.shrink(),
                    Some(:final value) => Column(
                        children: [
                          Text(
                            value.toString(),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'rating',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                  },
                  switch (audience) {
                    0 => const SizedBox.shrink(),
                    final value => Column(
                        children: [
                          Text(
                            NumberFormat.compact().format(value),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            'followers',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ],
                      ),
                  },
                ],
              ),
            ),
            // Text(
            //   user.bio,
            //   maxLines: 3,
            //   style: const TextStyle(
            //     fontSize: 14,
            //     fontWeight: FontWeight.w200,
            //   ),
            // ),
            CupertinoListSection.insetGrouped(
              backgroundColor: Colors.transparent,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                border: Border(
                  bottom: BorderSide(
                    color: theme.colorScheme.onBackground.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
              ),
              children: [
                switch (user.location) {
                  None() => const SizedBox.shrink(),
                  Some(:final value) => FutureBuilder<Option<PlaceData>>(
                      future: context.places.getPlaceById(value.placeId),
                      builder: (context, snapshot) {
                        final place = snapshot.data;

                        return switch (place) {
                          null => const CupertinoActivityIndicator(),
                          None() => const SizedBox.shrink(),
                          Some(:final value) => CupertinoListTile(
                              leading: const Icon(
                                Icons.location_on,
                              ),
                              title: Text(
                                getAddressComponent(
                                  value.addressComponents,
                                ).toLowerCase(),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                        };
                      },
                    ),
                },
                switch (rating) {
                  None() => const SizedBox.shrink(),
                  Some(:final value) => CupertinoListTile(
                      leading: const Icon(
                        CupertinoIcons.star_circle,
                      ),
                      title: RatingBarIndicator(
                        rating: value,
                        itemBuilder: (context, index) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        itemSize: 20,
                      ),
                    ),
                },
                switch (socialFollowing.instagramHandle) {
                  None() => const SizedBox.shrink(),
                  Some(:final value) => CupertinoListTile(
                      leading: const Icon(
                        FontAwesomeIcons.instagram,
                      ),
                      title: Text(
                        value,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: socialFollowing.instagramFollowers > 0
                          ? Text(
                              numberFormat.format(
                                socialFollowing.instagramFollowers,
                              ),
                            )
                          : null,
                    ),
                },
                switch (socialFollowing.twitterHandle) {
                  None() => const SizedBox.shrink(),
                  Some(:final value) => CupertinoListTile(
                      leading: const Icon(
                        FontAwesomeIcons.xTwitter,
                      ),
                      title: Text(
                        value,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      trailing: socialFollowing.twitterFollowers > 0
                          ? Text(
                              numberFormat
                                  .format(socialFollowing.twitterFollowers),
                            )
                          : null,
                    ),
                },
                // switch (socialFollowing.facebookHandle) {
                //   None() => const SizedBox.shrink(),
                //   Some(:final value) => CupertinoListTile(
                //       leading: const Icon(FontAwesomeIcons.facebook),
                //       title: Text(value),
                //       trailing: socialFollowing.facebookFollowers > 0
                //           ? Text(
                //               numberFormat.format(
                //                   socialFollowing.facebookFollowers),
                //             )
                //           : null,
                //     ),
                // },
                switch (socialFollowing.tiktokHandle) {
                  None() => const SizedBox.shrink(),
                  Some(:final value) => CupertinoListTile(
                      leading: const Icon(
                        FontAwesomeIcons.tiktok,
                      ),
                      title: Text(
                        value,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      subtitle: socialFollowing.tiktokFollowers > 0
                          ? Text(
                              numberFormat
                                  .format(socialFollowing.tiktokFollowers),
                            )
                          : null,
                    ),
                },
                // switch (socialFollowing.youtubeHandle) {
                //   None() => const SizedBox.shrink(),
                //   Some(:final value) => CupertinoListTile(
                //       leading: const Icon(FontAwesomeIcons.youtube),
                //       title: Text(value),
                //     ),
                // },
                // switch (socialFollowing.twitchHandle) {
                //   None() => const SizedBox.shrink(),
                //   Some(:final value) => CupertinoListTile(
                //       leading: const Icon(FontAwesomeIcons.twitch),
                //       title: Text(value),
                //     ),
                // },
                switch (socialFollowing.soundcloudHandle) {
                  None() => const SizedBox.shrink(),
                  Some(:final value) => CupertinoListTile(
                      leading: const Icon(
                        FontAwesomeIcons.soundcloud,
                      ),
                      title: Text(
                        value,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                },
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'contact - ${user.email}',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final theme = Theme.of(context);
    return Scaffold(
      // backgroundColor: Colors.grey[700],
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        // backgroundColor: Colors.grey[700],
        backgroundColor: theme.colorScheme.surface,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _shareWidgetAsImage,
        label: const Text('share'),
        icon: _shareLoading
            ? const CupertinoActivityIndicator()
            : const Icon(CupertinoIcons.share),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: switch (widget.user) {
          None() => FutureBuilder(
              future: database.getUserById(widget.userId),
              builder: (context, snapshot) {
                final user = snapshot.data;
                return switch (user) {
                  null => const CupertinoActivityIndicator(),
                  None() => const Text('user not found?'),
                  Some(:final value) => _buildProfileCard(context, user: value),
                };
              },
            ),
          Some(:final value) => _buildProfileCard(context, user: value),
        },
      ),
    );
  }
}
