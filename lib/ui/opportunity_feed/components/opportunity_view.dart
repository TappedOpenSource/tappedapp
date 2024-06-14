import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/opportunity_bloc/opportunity_bloc.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/opportunities/interested_users_view.dart';
import 'package:intheloopapp/ui/profile/profile_view.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/admin_builder.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intheloopapp/utils/opportunity_image.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:share_plus/share_plus.dart';
import 'package:skeleton_text/skeleton_text.dart';
import 'package:skeletons/skeletons.dart';

class OpportunityView extends StatelessWidget {
  const OpportunityView({
    required this.opportunityId,
    required this.opportunity,
    this.isApplied,
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
  final bool? isApplied;
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
    required UserModel currentUser,
  }) {
    final hero = heroImage;
    final opBloc = context.opportunities;
    final places = context.places;
    final database = context.database;
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: showAppBar ? AppBar() : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
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
              GestureDetector(
                onTap: () => context.push(
                  ImagePage(
                    heroImage: hero,
                  ),
                ),
                child: Hero(
                  tag: hero.heroTag,
                  child: opImage(hero.imageProvider),
                ),
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
                                'https://app.tapped.ai/opportunity/${op.id}';
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
                                final quota = opBloc.state.opQuota;
                                opBloc.add(
                                  ApplyForOpportunity(
                                    opportunity: op,
                                    userComment: '',
                                  ),
                                );
                                if (quota > 0) {
                                  onApply?.call();
                                }
                              },
                              color: Colors.green.withOpacity(0.8),
                              padding: const EdgeInsets.all(12),
                              child: const Text(
                                'Apply',
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          true => CupertinoButton(
                              onPressed: null,
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.1),
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
                  const SizedBox(height: 6),
                  AdminBuilder(
                    builder: (context, isAdmin) {
                      return switch (op.userId == currentUser.id || isAdmin) {
                        false => const SizedBox.shrink(),
                        true => Row(
                            children: [
                              Expanded(
                                child: CupertinoButton(
                                  onPressed: () {
                                    showCupertinoModalBottomSheet(
                                      context: context,
                                      builder: (context) => InterestedUsersView(
                                        opportunity: op,
                                      ),
                                    );
                                  },
                                  color: theme.colorScheme.primary,
                                  padding: const EdgeInsets.all(12),
                                  // borderRadius: BorderRadius.circular(15),
                                  child: const Text(
                                    'see applicants',
                                    style: TextStyle(
                                      fontSize: 17,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                      };
                    },
                  ),
                  const SizedBox(height: 12),
                  switch (op.venueId) {
                    None() => FutureBuilder<Option<PlaceData>>(
                        future: places.getPlaceById(
                          op.location.placeId,
                        ),
                        builder: (context, snapshot) {
                          final placeData = snapshot.data;
                          return switch (placeData) {
                            null => const CupertinoActivityIndicator(),
                            None() => const SizedBox.shrink(),
                            Some(:final value) => GestureDetector(
                                onTap: () => MapsLauncher.launchQuery(
                                  getAddressComponent(value.addressComponents),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      CupertinoIcons.location_circle_fill,
                                      color: theme.colorScheme.onSurface
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      getAddressComponent(
                                        value.addressComponents,
                                      ),
                                      style: const TextStyle(
                                        color: tappedAccent,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          };
                        },
                      ),
                    Some(:final value) => FutureBuilder<Option<UserModel>>(
                      future: database.getUserById(value),
                      builder: (context, snapshot) {
                        final requester = snapshot.data;
                        return switch (requester) {
                          null => SkeletonListTile(),
                          None() => SkeletonListTile(),
                          Some(:final value) => GestureDetector(
                            onTap: () =>
                                showCupertinoModalBottomSheet<void>(
                                  context: context,
                                  builder: (context) => ProfileView(
                                    visitedUserId: value.id,
                                    visitedUser: Option.of(value),
                                  ),
                                ),
                            child: CupertinoListTile(
                              leading: UserAvatar(
                                pushId: Option.of(value.id),
                                pushUser: Option.of(value),
                                imageUrl: value.profilePicture,
                                radius: 20,
                              ),
                              title: Text(
                                value.displayName,
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ),
                        };
                      },
                    ),
                  },
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.calendar_circle_fill,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('MM/dd/yyyy').format(op.startTime),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.money_dollar_circle_fill,
                        color: op.isPaid ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        op.isPaid ? 'paid' : 'unpaid',
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    op.description,
                  ),
                  const SizedBox(height: 12),
                  UserTile(
                    userId: op.userId,
                    user: const None(),
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
          return const SizedBox.shrink();
        }

        return switch (isApplied) {
          null => const FloatingActionButton(
              onPressed: null,
              child: CupertinoActivityIndicator(),
            ),
          false => FloatingActionButton.extended(
              onPressed: () {
                opBloc.add(
                  DislikeOpportunity(
                    opportunity: op,
                  ),
                );
                onDislike?.call();
              },
              backgroundColor: Colors.red,
              icon: const Icon(
                Icons.cancel,
              ),
              label: const Text('Not Interested'),
            ),
          true => const SizedBox.shrink(),
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
          future: isApplied == null
              ? database.isUserAppliedForOpportunity(
                  opportunityId: opportunityId,
                  userId: currentUser.id,
                )
              : Future<bool>.value(isApplied),
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
                          currentUser: currentUser,
                        ),
                    };
                  },
                ),
              Some(:final value) => buildOpportunityView(
                  context,
                  op: value,
                  isApplied: isApplied,
                  currentUser: currentUser,
                ),
            };
          },
        );
      },
    );
  }
}
