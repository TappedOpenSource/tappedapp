import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
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
import 'package:intheloopapp/ui/profile/components/header_sliver.dart';
import 'package:intheloopapp/ui/profile/components/info_sliver.dart';
import 'package:intheloopapp/ui/profile/components/opportunities_sliver.dart';
import 'package:intheloopapp/ui/profile/components/reviews_sliver.dart';
import 'package:intheloopapp/ui/profile/components/services_sliver.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/utils/default_image.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:intl/intl.dart';

import 'package:intheloopapp/ui/profile/components/claim_profile_button.dart';

class ProfileView extends StatelessWidget {
  ProfileView({
    required this.visitedUserId,
    required this.visitedUser,
    this.heroImage,
    this.titleHeroTag,
    this.collapsedBarHeight = 60.0,
    this.expandedBarHeight = 300.0,
    super.key,
  });

  final String visitedUserId;
  final double collapsedBarHeight;
  final double expandedBarHeight;
  final HeroImage? heroImage;
  final String? titleHeroTag;

  final scrollController = ScrollController();

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

  Widget _subheader(UserModel user) {
    final capacity = user.venueInfo.flatMap((t) => t.capacity);
    final socialFollowing = user.socialFollowing;
    final category = user.performerInfo.map((t) => t.category);
    return switch ((capacity, category)) {
      (None(), None()) => socialFollowing.audienceSize == 0
          ? const SizedBox.shrink()
          : Text(
              '${NumberFormat.compactCurrency(
                decimalDigits: 0,
                symbol: '',
              ).format(socialFollowing.audienceSize)} followers',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w400,
                fontSize: 12,
              ),
            ),
      (None(), Some(:final value)) => Text(
          '${value.formattedName} performer'.toLowerCase(),
          style: TextStyle(
            color: value.color,
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
      (Some(:final value), _) => Text(
          '$value capacity venue',
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
          ),
        ),
    };
  }

  Widget _profilePage(
    UserModel currentUser,
    UserModel visitedUser,
    DatabaseRepository databaseRepository,
    PlacesRepository places,
  ) =>
      BlocProvider(
        create: (context) => ProfileCubit(
          places: places,
          database: databaseRepository,
          currentUser: currentUser,
          visitedUser: visitedUser,
        )
          ..getLatestBookings()
          ..getLatestReview()
          ..initServices()
          ..initOpportunities()
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
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) =>
                    context.read<ProfileCubit>().onNotification(
                          scrollController,
                          expandedBarHeight,
                          collapsedBarHeight,
                        ),
                child: CustomScrollView(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
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
          backgroundColor: Theme.of(context).colorScheme.background,
          expandedHeight: expandedBarHeight,
          collapsedHeight: collapsedBarHeight,
          pinned: true,
          stretch: true,
          onStretchTrigger: () async {
            final cubit = context.read<ProfileCubit>();
            await Future.wait([
              HapticFeedback.mediumImpact(),
              cubit.getLatestBookings(),
              cubit.getLatestReview(),
              cubit.initServices(),
              cubit.initOpportunities(),
              cubit.refetchVisitedUser(),
              cubit.loadIsVerified(visitedUser.id),
            ]);
          },
          // automaticallyImplyLeading: false,
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
            title: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PremiumBuilder(
                  builder: (context, isPremium) {
                    final showClaim =
                        isPremium && currentUser.id == visitedUser.id;
                    return Text.rich(
                      TextSpan(
                        text: visitedUser.displayName,
                        style: GoogleFonts.manrope(
                          color: Colors.white,
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                        ),
                        children: [
                          if (state.isVerified || showClaim)
                            WidgetSpan(
                              child: Icon(
                                Icons.verified,
                                size: 18,
                                color: switch ((showClaim, state.isVerified)) {
                                  (true, _) => Colors.purple,
                                  (_, true) => tappedAccent,
                                  (_, false) => Colors.transparent,
                                },
                              ),
                              alignment: PlaceholderAlignment.middle,
                            ),
                        ],
                      ),
                      overflow: TextOverflow.fade,
                      maxLines: 2,
                    );
                  },
                ),
                _subheader(visitedUser),
              ],
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
        const SliverToBoxAdapter(
          child: OpportunitiesSliver(),
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
        const SliverToBoxAdapter(
          child: ServicesSliver(),
        ),
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
          stretch: true,
          backgroundColor: Theme.of(context).colorScheme.background,
          onStretchTrigger: () async {
            final cubit = context.read<ProfileCubit>();
            await Future.wait([
              cubit.getLatestBookings(),
              cubit.initServices(),
              cubit.initOpportunities(),
              cubit.refetchVisitedUser(),
              cubit.loadIsVerified(visitedUser.id),
            ]);
          },
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
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);
    final places = RepositoryProvider.of<PlacesRepository>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
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
                databaseRepository,
                places,
              ),
            (None(), false) => FutureBuilder<Option<UserModel>>(
                future: databaseRepository.getUserById(visitedUserId),
                builder: (context, snapshot) {
                  final user = snapshot.data;

                  return switch (user) {
                    null => const LoadingView(),
                    None() => const LoadingView(),
                    Some(:final value) => _profilePage(
                        currentUser,
                        value,
                        databaseRepository,
                        places,
                      ),
                  };
                },
              ),
            (Some(:final value), false) => _profilePage(
                currentUser,
                value,
                databaseRepository,
                places,
              ),
          };
        },
      ),
    );
  }
}
