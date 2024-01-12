import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/opportunity_bloc/opportunity_bloc.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/custom_claim_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intheloopapp/utils/opportunity_image.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeleton_text/skeleton_text.dart';

class OpportunityView extends StatelessWidget {
  const OpportunityView({
    required this.opportunity,
    this.onApply,
    this.onDislike,
    this.onDismiss,
    this.heroImage,
    this.titleHeroTag,
    this.showAppBar = true,
    this.showDislikeButton = true,
    super.key,
  });

  final Opportunity opportunity;
  final bool showDislikeButton;
  final bool showAppBar;
  final HeroImage? heroImage;
  final String? titleHeroTag;
  final void Function()? onApply;
  final void Function()? onDislike;
  final void Function()? onDismiss;

  Future<Option<Image>> nothing() async {
    return const None();
  }

  Widget opImage(ImageProvider provider) => Container(
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: provider,
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 600,
            sigmaY: 1000,
          ),
        ),
      );

  Widget buildOpportunityView(BuildContext context) {
    final hero = heroImage;
    final places = context.places;
    final theme = Theme.of(context);
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hero == null)
            FutureBuilder<ImageProvider>(
              future: getOpImage(context, opportunity),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SkeletonAnimation(
                    child: const SizedBox(
                      height: 400,
                      width: double.infinity,
                    ),
                  );
                }

                final provider = snapshot.data!;
                return opImage(provider);
              },
            )
          else
            Hero(
              tag: hero.heroTag,
              child: opImage(hero.imageProvider),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ConditionalParentWidget(
                  condition: titleHeroTag != null,
                  conditionalBuilder: ({required child}) => Hero(
                    tag: titleHeroTag!,
                    child: child,
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: opportunity.title,
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Rubik One',
                        fontWeight: FontWeight.w900,
                        color: theme.colorScheme.onBackground,
                      ),
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: GestureDetector(
                            onTap: () async {
                              final link =
                                  'https://tapped.ai/opportunity/${opportunity.id}';
                              await Share.share(link);
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Icon(
                                CupertinoIcons.share,
                                size: 18,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'booker',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UserTile(
                  userId: opportunity.userId,
                  user: const None(),
                ),
                const SizedBox(height: 12),
                const Text(
                  'description',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  opportunity.description,
                ),
                const SizedBox(height: 12),
                const Text(
                  'location',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder<PlaceData?>(
                  future: places.getPlaceById(
                    opportunity.placeId,
                  ),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const CupertinoActivityIndicator();
                    }

                    final place = snapshot.data!;
                    final formattedAddress = formattedFullAddress(
                      place.addressComponents,
                    );
                    return GestureDetector(
                      onTap: () => MapsLauncher.launchQuery(
                        formattedAddress,
                      ),
                      child: Text(
                        formattedAddress,
                        style: const TextStyle(
                          color: tappedAccent,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Text(
                  'date',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MM/dd/yyyy').format(opportunity.startTime),
                ),
                const SizedBox(height: 12),
                const Text(
                  'compensation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      color: opportunity.isPaid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      opportunity.isPaid ? 'paid' : 'unpaid',
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildApplyButton(
    OpportunityBloc opBloc,
    DatabaseRepository database,
  ) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        if (opportunity.userId == currentUser.id) {
          return CupertinoButton.filled(
            onPressed: () => context.push(
              InterestedUsersPage(
                opportunity: opportunity,
              ),
            ),
            child: const Text('see who applied'),
          );
        }

        return FutureBuilder(
          future: database.isUserAppliedForOpportunity(
            opportunity: opportunity,
            userId: currentUser.id,
          ),
          builder: (context, snapshot) {
            final isApplied = snapshot.data;
            return switch (isApplied) {
              null => const CupertinoActivityIndicator(),
              true => FilledButton(
                  onPressed: () {
                    onDismiss?.call();
                  },
                  child: const Text('already applied (click to dismiss)'),
                ),
              false => Row(
                  children: [
                    IconButton.filled(
                      onPressed: () {
                        opBloc.add(
                          DislikeOpportunity(
                            opportunity: opportunity,
                          ),
                        );
                        onDislike?.call();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.red,
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.xmark,
                        size: 42,
                      ),
                    ),
                    const SizedBox(width: 69),
                    CustomClaimBuilder(
                      builder: (context, claim) {
                        return IconButton.filled(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            opBloc.add(
                              ApplyForOpportunity(
                                opportunity: opportunity,
                                userComment: '',
                              ),
                            );
                            onApply?.call();
                          },
                          style: switch (claim) {
                            None() => ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  tappedAccent,
                                ),
                              ),
                            Some() => ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                  const Color(0xffffd700),
                                ),
                              ),
                          },
                          icon: switch (claim) {
                            None() => const Icon(
                                CupertinoIcons.star_fill,
                                size: 42,
                              ),
                            Some() => const Icon(
                                FontAwesomeIcons.bolt,
                                size: 42,
                              ),
                          },
                        );
                      },
                    ),
                  ],
                ),
            };
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final opBloc = context.opportunities;
    final database = context.database;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: showAppBar ? AppBar() : null,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: buildOpportunityView(
              context,
            ),
          ),
          Positioned(
            bottom: 42,
            child: buildApplyButton(
              opBloc,
              database,
            ),
          ),
        ],
      ),
    );
  }
}
