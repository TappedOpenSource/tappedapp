import 'package:cached_annotation/cached_annotation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/discover/components/user_slider.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/ui/profile/components/feedback_button.dart';
import 'package:intheloopapp/ui/profile/components/opportunities_list.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class DraggableSheet extends StatelessWidget {
  DraggableSheet({
    DraggableScrollableController? dragController,
    super.key,
  }) : dragController = dragController ?? DraggableScrollableController();

  final DraggableScrollableController dragController;

  @cached
  bool _isVenueGoodFit(UserModel currentUser, UserModel venue) {
    final category = currentUser.performerInfo.map((t) => t.category);
    final userGenres =
        currentUser.performerInfo.map((t) => t.genres).getOrElse(() => []);
    final goodCapFit =
        venue.venueInfo.flatMap((t) => t.capacity).map2(category, (cap, cat) {
      return cat.suggestedMaxCapacity >= cap;
    }).getOrElse(() => false);
    final genreFit = venue.venueInfo.map((t) {
      final one = Set<String>.from(t.genres.map((e) => e.toLowerCase()));
      final two = Set<String>.from(userGenres.map((e) => e.toLowerCase()));
      final intersect = one.intersection(two);
      return intersect.isNotEmpty;
    }).getOrElse(() => false);
    final isGoodFit = goodCapFit && genreFit;

    return isGoodFit;
  }

  Widget _venueTile(UserModel currentUser, UserModel venue) {
    final isGoodFit = _isVenueGoodFit(currentUser, venue);

    return UserTile(
      userId: venue.id,
      user: Option.of(venue),
      trailing: isGoodFit
          ? const Text(
              'for you',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
          : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final theme = Theme.of(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return PremiumBuilder(
          builder: (context, isPremium) {
            return BlocBuilder<DiscoverCubit, DiscoverState>(
              builder: (context, state) {
                final sortedVenueHits = List<UserModel>.from(state.venueHits)
                  ..sort((a, b) {
                    final aIsGoodFit = _isVenueGoodFit(currentUser, a);
                    final bIsGoodFit = _isVenueGoodFit(currentUser, b);

                    if (aIsGoodFit && !bIsGoodFit) {
                      return -1;
                    } else if (!aIsGoodFit && bIsGoodFit) {
                      return 1;
                    } else {
                      return 0;
                    }
                  });
                final topPerformerIds = sortedVenueHits.flatMap((v) {
                  return v.venueInfo.fold(
                    () => <String>[],
                    (t) => t.topPerformerIds,
                  );
                });
                return FutureBuilder(
                  future: database.getFeaturedOpportunities(),
                  builder: (context, snapshot) {
                    final featuredOpportunities = snapshot.data ?? [];
                    return FutureBuilder(
                      future: (() async {
                        final performers = (await Future.wait(
                          topPerformerIds.map(database.getUserById),
                        ))
                            .whereType<Some<UserModel>>()
                            .map((e) => e.value)
                            .toList();

                        return performers;
                      })(),
                      builder: (context, snapshot) {
                        final performers = snapshot.data ?? [];
                        return DraggableScrollableSheet(
                          expand: false,
                          minChildSize: 0.11,
                          snap: true,
                          snapSizes: const [0.11, 0.5, 1],
                          controller: dragController,
                          builder: (ctx, scrollController) => DecoratedBox(
                            decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(12),
                              ),
                              color: Theme.of(context).colorScheme.background,
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: scrollController,
                                    physics: const ClampingScrollPhysics(),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(12),
                                            ),
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                vertical: 32 / 2 - 4 / 2,
                                              ),
                                              child: Container(
                                                height: 4,
                                                width: 42,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(2),
                                                  color: theme
                                                      .colorScheme.onSurface
                                                      .withOpacity(0.15),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 24,
                                            left: 20,
                                            right: 20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const SizedBox(width: 35),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    '${state.venueHits.length}${state.venueHits.length >= 75 ? '+' : ''} ${state.venueHits.length == 1 ? 'venue' : 'venues'}',
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(
                                                height: 35,
                                                width: 35,
                                                padding:
                                                    const EdgeInsets.all(1),
                                                decoration: BoxDecoration(
                                                  color:
                                                      theme.colorScheme.primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    35.0 / 2,
                                                  ),
                                                ),
                                                child: UserAvatar(
                                                  radius: 45,
                                                  imageUrl: currentUser
                                                      .profilePicture,
                                                  pushUser:
                                                      Option.of(currentUser),
                                                  pushId:
                                                      Option.of(currentUser.id),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 20,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CupertinoButton(
                                                  onPressed: () => context.push(
                                                    GigSearchPage(),
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  color: theme
                                                      .colorScheme.primary
                                                      .withOpacity(0.1),
                                                  child: Text(
                                                    'build a show',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: theme
                                                          .colorScheme.primary,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 8,
                                            horizontal: 20,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: CupertinoButton(
                                                  onPressed: () {
                                                    final uri = Uri.parse(
                                                      'https://tapped.tolt.io',
                                                    );
                                                    launchUrl(uri);
                                                  },
                                                  borderRadius: BorderRadius.circular(15),
                                                  color: Colors.purple
                                                      .withOpacity(0.1),
                                                  child: const Text(
                                                    'join the team',
                                                    style: TextStyle(
                                                      fontWeight:
                                                      FontWeight.bold,
                                                      color: Colors.purple,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        CustomClaimsBuilder(
                                          builder: (context, claims) {
                                            final isAdmin = claims
                                                .contains(CustomClaim.admin);
                                            final isBooker = claims
                                                .contains(CustomClaim.booker);
                                            return switch (
                                                isAdmin || isBooker) {
                                              false => const SizedBox.shrink(),
                                              true => Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                    horizontal: 20,
                                                  ),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: CupertinoButton(
                                                      onPressed: () => context
                                                          .push(AdminPage()),
                                                      color: Colors.red
                                                          .withOpacity(0.1),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        15,
                                                      ),
                                                      child: const Text(
                                                        'add opportunity',
                                                        style: TextStyle(
                                                          color: Colors.red,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                            };
                                          },
                                        ),
                                        ...sortedVenueHits.take(3).map(
                                              (venue) => _venueTile(
                                                currentUser,
                                                venue,
                                              ),
                                            ),
                                        if (sortedVenueHits.length > 3)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              GestureDetector(
                                                onTap: () =>
                                                    showCupertinoModalBottomSheet<
                                                        void>(
                                                  context: context,
                                                  builder: (context) =>
                                                      Scaffold(
                                                    appBar: AppBar(
                                                      title:
                                                          const Text('venues'),
                                                    ),
                                                    body: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        vertical: 16,
                                                      ),
                                                      decoration: BoxDecoration(
                                                        color: theme.colorScheme
                                                            .background,
                                                      ),
                                                      child: ListView.builder(
                                                        itemCount:
                                                            sortedVenueHits
                                                                .length,
                                                        itemBuilder:
                                                            (context, index) {
                                                          final venue =
                                                              sortedVenueHits[
                                                                  index];
                                                          return _venueTile(
                                                            currentUser,
                                                            venue,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                child: Text(
                                                  'view all',
                                                  style: TextStyle(
                                                    color: theme
                                                        .colorScheme.primary,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (state.genreCounts.isNotEmpty)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              'top genres in area',
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        if (state.genreCounts.isNotEmpty)
                                          SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: state.genreCounts
                                                  .map(
                                                    (e) => Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 4,
                                                      ),
                                                      child: Chip(
                                                        label: Text(
                                                          e.key,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                  .toList(),
                                            ),
                                          ),
                                        if (topPerformerIds.isNotEmpty)
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 8,
                                            ),
                                            child: Text(
                                              'top performers in area',
                                              style: TextStyle(
                                                fontSize: 28,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        if (topPerformerIds.isNotEmpty)
                                          UserSlider(
                                            users: performers,
                                            sort: true,
                                            blur: !isPremium,
                                            onTap: isPremium
                                                ? null
                                                : () =>
                                                    context.push(PaywallPage()),
                                          ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            'biggest risers',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: database.getBookingLeaders(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                child:
                                                    CupertinoActivityIndicator(),
                                              );
                                            }

                                            final bookingLeaders =
                                                snapshot.data ?? [];
                                            return UserSlider(
                                              users: bookingLeaders,
                                            );
                                          },
                                        ),

                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            'the greats',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        FutureBuilder(
                                          future: database.getFeaturedPerformers(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                child:
                                                CupertinoActivityIndicator(),
                                              );
                                            }

                                            final bookingLeaders =
                                                snapshot.data ?? [];
                                            return UserSlider(
                                              users: bookingLeaders,
                                              sort: true,
                                              blur: !isPremium,
                                              onTap: isPremium
                                                  ? null
                                                  : () =>
                                                  context.push(PaywallPage()),
                                            );
                                          },
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 8,
                                          ),
                                          child: Text(
                                            'apply to perform',
                                            style: TextStyle(
                                              fontSize: 28,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        OpportunitiesList(
                                          opportunities: featuredOpportunities,
                                        ),
                                        const SizedBox(height: 10),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                            horizontal: 20,
                                          ),
                                          child: Column(
                                            children: [
                                              const Row(
                                                children: [
                                                  Expanded(
                                                    child: FeedbackButton(),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: CupertinoButton(
                                                      onPressed: () {
                                                        final uri = Uri.parse(
                                                          'https://tappedapp.notion.site/join-tapped-9ccf655358344b21979f73adadf22d98?pvs=4',
                                                        );
                                                        launchUrl(uri);
                                                      },
                                                      color: theme
                                                          .colorScheme.onSurface
                                                          .withOpacity(0.1),
                                                      padding:
                                                          const EdgeInsets.all(
                                                        12,
                                                      ),
                                                      child: const Text(
                                                        'want a job?',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 50,
                                        ),
                                      ],
                                    ),
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
              },
            );
          },
        );
      },
    );
  }
}
