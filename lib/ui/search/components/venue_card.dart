import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/models/venue_info.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class VenueCard extends StatelessWidget {
  const VenueCard({
    required this.venue,
    super.key,
  });

  final UserModel venue;

  @override
  Widget build(BuildContext context) {
    if (venue.deleted) return const SizedBox.shrink();

    final database = context.database;
    final imageUrl = venue.profilePicture.toNullable();

    final venueType =
        venue.venueInfo.map((e) => e.type).getOrElse(() => VenueType.other);
    return FutureBuilder(
      future: database.isVerified(venue.id),
      builder: (context, snapshot) {
        final verified = snapshot.data ?? false;
        final provider = (imageUrl == null || imageUrl.isEmpty)
            ? const AssetImage('assets/default_avatar.png') as ImageProvider
            : CachedNetworkImageProvider(
                imageUrl,
              );
        final uuid = const Uuid().v4();
        final heroImageTag = 'user-image-${venue.id}-$uuid';
        final heroTitleTag = 'user-title-${venue.id}-$uuid';
        return SizedBox(
          width: 200,
          height: 200,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: () => context.push(
                  ProfilePage(
                    userId: venue.id,
                    user: Option.of(venue),
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
                              text: venue.displayName,
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
                          if (venueType != VenueType.other)
                            Text(
                              venueType.name.capitalize(),
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
  }
}
