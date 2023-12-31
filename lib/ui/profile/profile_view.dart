import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/conditional_parent_widget.dart';
import 'package:intheloopapp/ui/error/error_view.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/profile/components/bookings_sliver.dart';
import 'package:intheloopapp/ui/profile/components/common_followers_sliver.dart';
import 'package:intheloopapp/ui/profile/components/header_sliver.dart';
import 'package:intheloopapp/ui/profile/components/info_sliver.dart';
import 'package:intheloopapp/ui/profile/components/opportunities_sliver.dart';
import 'package:intheloopapp/ui/profile/components/reviews_sliver.dart';
import 'package:intheloopapp/ui/profile/components/services_sliver.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/utils/hero_image.dart';

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
        ? const AssetImage(
            'assets/default_avatar.png',
          ) as ImageProvider
        : CachedNetworkImageProvider(
            profilePicture,
          );
  }

  Widget _profileImage(String? profilePicture) {
    final hero = heroImage;
    return ConditionalParentWidget(
      condition: hero != null,
      conditionalBuilder: ({required child}) {
        return Hero(
          tag: hero!.heroTag,
          child: child,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: _getProfileImage(profilePicture),
          ),
        ),
      ),
    );
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
          databaseRepository: databaseRepository,
          currentUser: currentUser,
          visitedUser: visitedUser,
        )
          ..getLatestBooking()
          ..getLatestReview()
          ..initBadges()
          ..initServices()
          ..initOpportunities()
          ..loadIsFollowing(currentUser.id, visitedUser.id)
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
                          currentUser,
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
              // cubit.getLatestLoop(),
              // cubit.getLatestOpportunity(),
              cubit.getLatestBooking(),
              cubit.getLatestReview(),
              cubit.initBadges(),
              cubit.initServices(),
              cubit.initOpportunities(),
              cubit.refetchVisitedUser(),
              cubit.loadIsFollowing(currentUser.id, visitedUser.id),
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
                Text.rich(
                  TextSpan(
                    text: visitedUser.displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
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
                        ),
                    ],
                  ),
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                ),
                Text(
                  visitedUser.occupations.join(', '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.grey[300],
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
            background: _profileImage(visitedUser.profilePicture),
          ),
        ),
        const SliverToBoxAdapter(
          child: HeaderSliver(),
        ),
        //const
        const SliverToBoxAdapter(
          child: SizedBox(height: 8),
        ),
        SliverToBoxAdapter(
          child: GestureDetector(
            onTap: () => context.push(
              FollowRelationshipPage(
                userId: state.visitedUser.id,
                index: 0,
              ),
            ),
            child: const CommonFollowersSliver(),
          ),
        ),
        const SliverToBoxAdapter(
          child: OpportunitiesSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
        const SliverToBoxAdapter(
          child: ReviewsSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
        const SliverToBoxAdapter(
          child: BookingsSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 18),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 18),
        ),
        const SliverToBoxAdapter(
          child: ServicesSliver(),
        ),
        const SliverToBoxAdapter(
          child: SizedBox(height: 12),
        ),
        const SliverToBoxAdapter(
          child: InfoSliver(),
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
    UserModel currentUser,
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
              cubit.getLatestBooking(),
              cubit.initBadges(),
              cubit.initServices(),
              cubit.refetchVisitedUser(),
              cubit.loadIsFollowing(currentUser.id, visitedUser.id),
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
            background: _profileImage(visitedUser.profilePicture),
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
