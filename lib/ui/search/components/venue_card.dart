import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

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
    final imageUrl = venue.profilePicture.asNullable();

    final audienceText = '${NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
    ).format(venue.socialFollowing.audienceSize)} followers';
    final venueText = venue
        .venueInfo
        .map((e) => e.capacity.map((cap) => '$cap capacity'))
        .unwrapOr(Some(audienceText))
        .unwrapOr(audienceText);

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
          width: 150,
          height: 150,
          child: Stack(
            fit: StackFit.expand,
            children: [
              GestureDetector(
                onTap: () => context.push(
                  ProfilePage(
                    userId: venue.id,
                    user: Some(venue),
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
                          Text(
                             venueText,
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
