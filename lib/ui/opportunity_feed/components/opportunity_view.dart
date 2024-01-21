import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intheloopapp/utils/opportunity_image.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeleton_text/skeleton_text.dart';

class OpportunityView extends StatelessWidget {
  const OpportunityView({
    required this.opportunityId,
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

  final String opportunityId;
  final Option<Opportunity> opportunity;
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

  Widget buildOpportunityView(
    BuildContext context, {
    required Opportunity op,
    required bool? isApplied,
  }) {
    final hero = heroImage;
    final opBloc = context.opportunities;
    final places = context.places;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: showAppBar ? AppBar() : null,
      floatingActionButton: buildFloatingActionButton(
        context,
        opBloc: opBloc,
        op: op,
        isApplied: isApplied,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hero == null)
              FutureBuilder<ImageProvider>(
                future: getOpImage(context, op),
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
                    child: Text(
                      op.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontFamily: 'Rubik One',
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          onPressed: () {
                            final link =
                                'https://tapped.ai/opportunity/${op.id}';
                            Share.share(link);
                          },
                          color: theme.colorScheme.onSurface.withOpacity(0.1),
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            'Share',
                            style: TextStyle(
                              fontSize: 17,
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Expanded(
                        child: switch (isApplied) {
                          null => const CupertinoButton(
                              onPressed: null,
                              child: CupertinoActivityIndicator(),
                            ),
                          false => CupertinoButton(
                              onPressed: () {
                                HapticFeedback.mediumImpact();
                                opBloc.add(
                                  ApplyForOpportunity(
                                    opportunity: op,
                                    userComment: '',
                                  ),
                                );
                                onApply?.call();
                              },
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.1),
                              padding: const EdgeInsets.all(12),
                              child: const Text(
                                'Apply',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          true => CupertinoButton(
                              onPressed: null,
                              color: theme.colorScheme.onSurface
                                  .withOpacity(0.1),
                              padding: const EdgeInsets.all(12),
                              child: const Text(
                                'Apply',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        },
                      ),
                    ],
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
                      op.location.placeId,
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
                    DateFormat('MM/dd/yyyy').format(op.startTime),
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
                        color: op.isPaid ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        op.isPaid ? 'paid' : 'unpaid',
                      ),
                    ],
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
                    userId: op.userId,
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
                    op.description,
                  ),
                  const SizedBox(height: 96),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFloatingActionButton(
    context, {
    required Opportunity op,
    required OpportunityBloc opBloc,
    required bool? isApplied,
  }) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        if (op.userId == currentUser.id) {
          return FloatingActionButton.extended(
            onPressed: () => context.push(
              InterestedUsersPage(
                opportunity: op,
              ),
            ),
            label: const Text('see who applied'),
          );
        }

        return switch (isApplied) {
          null => const FloatingActionButton(
              onPressed: null,
              child: CupertinoActivityIndicator(),
            ),
          false => FloatingActionButton(
              onPressed: () {
                opBloc.add(
                  DislikeOpportunity(
                    opportunity: op,
                  ),
                );
                onDislike?.call();
              },
              backgroundColor: Colors.red,
              child: const Icon(
                CupertinoIcons.xmark,
              ),
            ),
          true => FloatingActionButton.extended(
              onPressed: () {
                onDismiss?.call();
              },
              label: const Text('already applied (click to dismiss)'),
              icon: const Icon(
                CupertinoIcons.xmark,
              ),
            ),
        };
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return FutureBuilder(
          future: database.isUserAppliedForOpportunity(
            opportunityId: opportunityId,
            userId: currentUser.id,
          ),
          builder: (context, snapshot) {
            final isApplied = snapshot.data;
            return switch (opportunity) {
              None() => FutureBuilder<Option<Opportunity>>(
                  future: database.getOpportunityById(opportunityId),
                  builder: (context, snapshot) {
                    final op = snapshot.data;
                    return switch (op) {
                      null => const Center(
                          child: CupertinoActivityIndicator(),
                        ),
                      None() => const Center(
                          child: Text('error'),
                        ),
                      Some(:final value) => buildOpportunityView(
                          context,
                          op: value,
                          isApplied: isApplied,
                        ),
                    };
                  },
                ),
              Some(:final value) => buildOpportunityView(
                  context,
                  op: value,
                  isApplied: isApplied,
                ),
            };
          },
        );
      },
    );
  }
}
