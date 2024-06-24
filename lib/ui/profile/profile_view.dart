import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/spotify_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/error/error_view.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/profile/components/bio_sliver.dart';
import 'package:intheloopapp/ui/profile/components/booking_controls_sliver.dart';
import 'package:intheloopapp/ui/profile/components/bookings_sliver.dart';
import 'package:intheloopapp/ui/profile/components/claim_profile_button.dart';
import 'package:intheloopapp/ui/profile/components/header_sliver.dart';
import 'package:intheloopapp/ui/profile/components/info_sliver.dart';
import 'package:intheloopapp/ui/profile/components/opportunities_sliver.dart';
import 'package:intheloopapp/ui/profile/components/reviews_sliver.dart';
import 'package:intheloopapp/ui/profile/components/social_media_icons.dart';
import 'package:intheloopapp/ui/profile/components/top_performers_sliver.dart';
import 'package:intheloopapp/ui/profile/components/top_tracks_sliver.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/default_image.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intheloopapp/utils/premium_builder.dart';

class ProfileView extends StatelessWidget {
  ProfileView({
    required this.visitedUserId,
    required this.visitedUser,
    this.heroImage,
    this.titleHeroTag,
    this.onQuit,
    this.collapsedBarHeight = 60.0,
    this.expandedBarHeight = 300.0,
    this.stretchable = false,
    super.key,
    ScrollController? scrollController,
  }) : scrollController = scrollController ?? ScrollController();

  final String visitedUserId;
  final double collapsedBarHeight;
  final double expandedBarHeight;
  final bool stretchable;
  final HeroImage? heroImage;
  final String? titleHeroTag;
  final void Function()? onQuit;
  final ScrollController scrollController;

  // callers can provide a user to avoid a database call
  final Option<UserModel> visitedUser;

  ImageProvider _getProfileImage(String? profilePicture) {
    return (profilePicture == null)
        ? getDefaultImage(Option.of(visitedUserId))
        : CachedNetworkImageProvider(
            profilePicture,
          );
  }

  Widget _profileImage(BuildContext context, String? profilePicture) {
    final hero = heroImage;
    final imageProvider = _getProfileImage(profilePicture);
    return ConditionalParentWidget(
      condition: hero != null,
      conditionalBuilder: ({required child}) {
        return Hero(
          tag: hero!.heroTag,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () => context.push(
          ImagePage(
            heroImage: heroImage ??
                HeroImage(
                  heroTag: titleHeroTag ?? visitedUserId,
                  imageProvider: imageProvider,
                ),
          ),
        ),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: imageProvider,
                ),
              ),
            ),
            Container(
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
          ],
        ),
      ),
    );
  }

  Widget _profilePage(
    UserModel currentUser,
    UserModel visitedUser,
    DatabaseRepository databaseRepository,
    PlacesRepository places,
    SpotifyRepository spotify,
  ) =>
      BlocProvider(
        create: (context) => ProfileCubit(
          spotify: spotify,
          places: places,
          database: databaseRepository,
          currentUser: currentUser,
          visitedUser: visitedUser,
        )
          ..getTopBookings()
          ..getLatestReview()
          // ..initServices()
          ..initOpportunities()
          ..initTopSpotifyTracks()
          ..loadIsBlocked()
          ..loadIsVerified(visitedUser.id)
          ..initPlace(),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            return BlocListener<OnboardingBloc, OnboardingState>(
              listener: (context, userState) {
                if (userState is Onboarded) {
                  if (userState.currentUser.id == visitedUser.id) {
                    context
                        .read<ProfileCubit>()
                        .refetchVisitedUser(newUserData: userState.currentUser);
                  }
                }
              },
              child: ConditionalParentWidget(
                condition: stretchable,
                conditionalBuilder: ({required child}) {
                  return NotificationListener<ScrollNotification>(
                    onNotification: (notification) =>
                        context.read<ProfileCubit>().onNotification(
                              scrollController,
                              expandedBarHeight,
                              collapsedBarHeight,
                            ),
                    child: child,
                  );
                },
                child: CustomScrollView(
                  controller: scrollController,
                  physics: stretchable
                      ? const BouncingScrollPhysics()
                      : const ClampingScrollPhysics(),
                  slivers: state.isBlocked
                      ? _blockedSlivers(
                          context,
                          state,
                          visitedUser,
                        )
                      : _unblockedSlivers(
                          context,
                          state,
                          currentUser,
                          visitedUser,
                        ),
                ),
              ),
            );
          },
        ),
      );

  List<Widget> _unblockedSlivers(
    BuildContext context,
    ProfileState state,
    UserModel currentUser,
    UserModel visitedUser,
  ) =>
      [
        SliverAppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          expandedHeight: expandedBarHeight,
          collapsedHeight: collapsedBarHeight,
          automaticallyImplyLeading: false,
          pinned: true,
          stretch: stretchable,
          onStretchTrigger: stretchable
              ? () async {
                  final cubit = context.read<ProfileCubit>();
                  await Future.wait([
                    HapticFeedback.mediumImpact(),
                    cubit.getTopBookings(),
                    cubit.getLatestReview(),
                    // cubit.initServices(),
                    cubit.initOpportunities(),
                    cubit.initTopSpotifyTracks(),
                    cubit.refetchVisitedUser(),
                    cubit.loadIsVerified(visitedUser.id),
                  ]);
                }
              : null,
          actions: [
            IconButton(
              onPressed: onQuit ?? () => context.pop(),
              icon: Icon(
                CupertinoIcons.xmark_circle_fill,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            titlePadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            centerTitle: false,
            title: PremiumBuilder(
              builder: (context, isPremium) {
                final theme = Theme.of(context);
                return Text.rich(
                  TextSpan(
                    text: visitedUser.displayName,
                    children: [
                      if (state.isVerified)
                        WidgetSpan(
                          child: GestureDetector(
                            onTap: () => showModalBottomSheet(
                              context: context,
                              showDragHandle: true,
                              builder: (context) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 300,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.verified,
                                          color: theme.colorScheme.primary,
                                          size: 96,
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          '${state.visitedUser.displayName} has been verified',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 18),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.lightbulb,
                                              color: Colors.amber,
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'to get verified, post a screenshot of your profile to your instagram story and tag us @tappedai',
                                                maxLines: 2,
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme.onSurface
                                                      .withOpacity(0.5),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                            child: const Icon(
                              Icons.verified,
                              size: 18,
                              color: tappedAccent,
                            ),
                          ),
                          alignment: PlaceholderAlignment.middle,
                        ),
                    ],
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                  )
                );
              },
            ),
            background: _profileImage(
              context,
              visitedUser.profilePicture.toNullable(),
            ),
          ),
        ),
        const SliverToBoxAdapter(
          child: HeaderSliver(),
        ),
        if (state.isCurrentUser)
          const SliverToBoxAdapter(
            child: BookingControlsSliver(),
          ),
        const SliverToBoxAdapter(
          child: InfoSliver(),
        ),
        const SocialMediaIcons(),
        const SliverToBoxAdapter(
          child: OpportunitiesSliver(),
        ),
        const SliverToBoxAdapter(
          child: TopPerformersSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
        const SliverToBoxAdapter(
          child: TopTracksSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
        const SliverToBoxAdapter(
          child: BookingsSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
        const SliverToBoxAdapter(
          child: ReviewsSliver(),
        ),
        // const SliverToBoxAdapter(
        //   child: ServicesSliver(),
        // ),
        const SliverToBoxAdapter(
          child: BioSliver(),
        ),
        if (state.visitedUser.unclaimed)
          const SliverToBoxAdapter(
            child: ClaimProfileButton(),
          ),
        const SliverToBoxAdapter(
          child: SizedBox(
            height: 50,
          ),
        ),
      ];

  List<Widget> _blockedSlivers(
    BuildContext context,
    ProfileState state,
    UserModel visitedUser,
  ) =>
      [
        SliverAppBar(
          expandedHeight: expandedBarHeight,
          collapsedHeight: collapsedBarHeight,
          pinned: true,
          stretch: stretchable,
          backgroundColor: Theme.of(context).colorScheme.surface,
          onStretchTrigger: stretchable
              ? () async {
                  final cubit = context.read<ProfileCubit>();
                  await Future.wait([
                    cubit.getTopBookings(),
                    cubit.initServices(),
                    cubit.initOpportunities(),
                    cubit.initTopSpotifyTracks(),
                    cubit.refetchVisitedUser(),
                    cubit.loadIsVerified(visitedUser.id),
                  ]);
                }
              : null,
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [
              StretchMode.zoomBackground,
              StretchMode.fadeTitle,
            ],
            titlePadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            centerTitle: false,
            title: Text.rich(
              TextSpan(
                text: visitedUser.artistName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                ),
                children: [
                  if (state.isVerified)
                    const WidgetSpan(
                      child: Icon(
                        Icons.verified,
                        size: 18,
                        color: tappedAccent,
                      ),
                      alignment: PlaceholderAlignment.middle,
                    )
                  else
                    const WidgetSpan(
                      child: SizedBox.shrink(),
                    ),
                ],
              ),
              overflow: TextOverflow.fade,
              maxLines: 2,
            ),
            background: _profileImage(
              context,
              visitedUser.profilePicture.toNullable(),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 50),
              const Text(
                'Blocked',
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'You have blocked this user, and they cannot see your profile.',
                textAlign: TextAlign.center,
              ),
              FilledButton(
                onPressed: () => context.read<ProfileCubit>().unblock(),
                child: const Text('Unblock'),
              ),
            ],
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final places = context.places;
    final spotify = context.spotify;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<OnboardingBloc, OnboardingState>(
        // selector: (state) => (state is Onboarded) ? state.currentUser : null,
        buildWhen: (previous, current) {
          if (previous is Onboarded && current is Onboarded) {
            return previous.currentUser.id != current.currentUser.id;
          }

          return true;
        },
        builder: (context, state) {
          final currentUser = (state is Onboarded) ? state.currentUser : null;
          if (currentUser == null) {
            return const ErrorView();
          }

          return switch ((visitedUser, currentUser.id == visitedUserId)) {
            (_, true) => _profilePage(
                currentUser,
                currentUser,
                database,
                places,
                spotify,
              ),
            (None(), false) => FutureBuilder<Option<UserModel>>(
                future: database.getUserById(visitedUserId),
                builder: (context, snapshot) {
                  final user = snapshot.data;

                  return switch (user) {
                    null => const LoadingView(),
                    None() => const LoadingView(),
                    Some(:final value) => _profilePage(
                        currentUser,
                        value,
                        database,
                        places,
                        spotify,
                      ),
                  };
                },
              ),
            (Some(:final value), false) => _profilePage(
                currentUser,
                value,
                database,
                places,
                spotify,
              ),
          };
        },
      ),
    );
  }
}
