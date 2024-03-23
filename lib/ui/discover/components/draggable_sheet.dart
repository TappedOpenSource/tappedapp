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
import 'package:url_launcher/url_launcher.dart';

class DraggableSheet extends StatelessWidget {
  const DraggableSheet({super.key});

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
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.11,
              minChildSize: 0.11,
              snap: true,
              snapSizes: const [0.11, 0.5, 1],
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 32 / 2 - 4 / 2,
                                  ),
                                  child: Container(
                                    height: 4,
                                    width: 42,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(2),
                                      color: theme.colorScheme.onSurface
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${state.venueHits.length} ${state.venueHits.length == 1 ? 'venue' : 'venues'}',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 35,
                                    width: 35,
                                    padding: const EdgeInsets.all(1),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.primary,
                                      borderRadius:
                                          BorderRadius.circular(35.0 / 2),
                                    ),
                                    child: UserAvatar(
                                      radius: 45,
                                      imageUrl: currentUser.profilePicture,
                                      pushUser: Option.of(currentUser),
                                      pushId: Option.of(currentUser.id),
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
                                        GigSearchInitPage(),
                                      ),
                                      borderRadius: BorderRadius.circular(15),
                                      color: theme.colorScheme.primary
                                          .withOpacity(0.1),
                                      child: Text(
                                        'get booked',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            CustomClaimsBuilder(
                              builder: (context, claims) {
                                final isAdmin =
                                    claims.contains(CustomClaim.admin);
                                final isBooker =
                                    claims.contains(CustomClaim.booker);
                                return switch (isAdmin || isBooker) {
                                  false => const SizedBox.shrink(),
                                  true => Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                        horizontal: 20,
                                      ),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: CupertinoButton(
                                          onPressed: () =>
                                              context.push(AdminPage()),
                                          color: Colors.red.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(15),
                                          child: const Text(
                                            'add opportunity',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                };
                              },
                            ),
                            ...sortedVenueHits
                                .map((venue) => _venueTile(currentUser, venue)),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8,
                              ),
                              child: Text(
                                'top performers',
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
                                    child: CupertinoActivityIndicator(),
                                  );
                                }

                                final bookingLeaders = snapshot.data ?? [];
                                return UserSlider(users: bookingLeaders);
                              },
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 8,
                              ),
                              child: Text(
                                'top gig opportunities',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FutureBuilder(
                              future: database.getFeaturedOpportunities(),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CupertinoActivityIndicator(),
                                  );
                                }

                                final featuredOpportunities =
                                    snapshot.data ?? [];
                                return OpportunitiesList(
                                  opportunities: featuredOpportunities,
                                );
                              },
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
                                          color: theme.colorScheme.onSurface
                                              .withOpacity(0.1),
                                          padding: const EdgeInsets.all(12),
                                          child: const Text(
                                            'want a job?',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
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
  }
}
