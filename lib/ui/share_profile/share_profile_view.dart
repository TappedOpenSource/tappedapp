import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import 'package:skeletons/skeletons.dart';

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
      await FirebaseAnalytics.instance.logEvent(
        name: 'share_profile',
        parameters: {
          'user_id': widget.userId,
          'type': 'image',
          'from': 'profile_share_page',
        },
      );

      final image = await _screenshotController.capture();
      if (image == null) {
        logger.debug('image is null');
        return;
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
    // const borderRadius = 25.0;
    // final bookingCount = user.performerInfo.map((t) => t.bookingCount);
    final reviewCount = user.performerInfo.map((t) => t.reviewCount);
    final audience = user.socialFollowing.audienceSize;
    final rating = user.performerInfo.flatMap((t) => t.rating);
    final socialFollowing = user.socialFollowing;
    final numberFormat = NumberFormat.compact();
    final genres = user.performerInfo.map((t) => t.genres).getOrElse(() => []);
    final label = user.performerInfo.map((t) => t.label);
    final category = user.performerInfo.map((t) => t.category);
    final averagePerformerTicketPrice =
        user.performerInfo.map((t) => t.formattedPriceRange);
    return Screenshot(
      controller: _screenshotController,
      child: AspectRatio(
        aspectRatio: 1 / 1.6,
        // child: ConstrainedBox(
        //   constraints: BoxConstraints(
        //     maxHeight: 600,
        //   ),
        child: Container(
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Container(
                      height: double.infinity,
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
                      height: double.infinity,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
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
                          switch (category) {
                            None() => const SizedBox.shrink(),
                            Some(:final value) => Text(
                                '${value.formattedName.toLowerCase()} performer',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: value.color,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                          },
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 10,
                  left: 20,
                  right: 20,
                ),
                child: Text(
                  user.bio,
                  maxLines: 3,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
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
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                children: [
                  switch (user.location) {
                    None() => const SizedBox.shrink(),
                    Some(:final value) => FutureBuilder<Option<PlaceData>>(
                        future: context.places.getPlaceById(value.placeId),
                        builder: (context, snapshot) {
                          final place = snapshot.data;

                          return switch (place) {
                            null => SkeletonListTile(),
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
                  switch (genres.isNotEmpty) {
                    false => const SizedBox.shrink(),
                    true => CupertinoListTile(
                        leading: const Icon(
                          Icons.music_note,
                        ),
                        title: Text(
                          genres.length > 3
                              ? genres.sublist(0, 3).join(', ').toLowerCase()
                              : genres.join(', ').toLowerCase(),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                  },
                  switch (label) {
                    None() => const SizedBox.shrink(),
                    Some(:final value) => CupertinoListTile(
                        leading: const Icon(
                          Icons.label,
                        ),
                        title: Text(
                          value.toLowerCase(),
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
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
                        subtitle: const Text(
                          'rating on tapped.ai',
                        ),
                      ),
                  },
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    switch (socialFollowing.tiktokHandle) {
                      None() => null,
                      Some(:final value) => Container(
                          decoration: BoxDecoration(
                            // color:
                            // theme.colorScheme.onBackground.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          child: Row(
                            children: [
                              const Icon(FontAwesomeIcons.tiktok, size: 20),
                              if (socialFollowing.tiktokFollowers > 0)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    numberFormat.format(
                                      socialFollowing.tiktokFollowers,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    },
                    switch (socialFollowing.instagramHandle) {
                      None() => null,
                      Some(:final value) => Container(
                          decoration: BoxDecoration(
                            // color:
                            // theme.colorScheme.onBackground.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.instagram,
                                size: 20,
                              ),
                              if (socialFollowing.instagramFollowers > 0)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    numberFormat.format(
                                      socialFollowing.instagramFollowers,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    },
                    switch (socialFollowing.twitterHandle) {
                      None() => null,
                      Some(:final value) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                FontAwesomeIcons.xTwitter,
                                size: 20,
                              ),
                              if (socialFollowing.twitterFollowers > 0)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    numberFormat.format(
                                      socialFollowing.twitterFollowers,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    },
                    switch (socialFollowing.facebookHandle) {
                      None() => null,
                      Some(:final value) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          child: Row(
                            children: [
                              const Icon(FontAwesomeIcons.facebook, size: 20),
                              if (socialFollowing.facebookFollowers > 0)
                                Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Text(
                                    numberFormat.format(
                                      socialFollowing.facebookFollowers,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                    },
                    switch (socialFollowing.youtubeHandle) {
                      None() => null,
                      Some(:final value) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          child: const Icon(FontAwesomeIcons.youtube, size: 20),
                        ),
                    },
                    switch (socialFollowing.twitchHandle) {
                      None() => null,
                      Some(:final value) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          child: const Icon(FontAwesomeIcons.twitch, size: 20),
                        ),
                    },
                    switch (socialFollowing.soundcloudHandle) {
                      None() => null,
                      Some(:final value) => Container(
                          decoration: BoxDecoration(
                            // color:
                            // theme.colorScheme.onBackground.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          child:
                              const Icon(FontAwesomeIcons.soundcloud, size: 20),
                        ),
                    },
                  ].whereType<Widget>().toList(),
                ),
              ),
              if (user.email.isNotEmpty && !user.email.contains('@tapped.ai'))
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
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
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'contact - https://app.tapped.ai/u/${user.username}',
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
