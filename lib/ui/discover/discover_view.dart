import 'package:badges/badges.dart' as badges;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/ui/discover/components/draggable_sheet.dart';
import 'package:intheloopapp/ui/discover/components/map_base.dart';
import 'package:intheloopapp/ui/discover/components/map_settings.dart';
import 'package:intheloopapp/ui/discover/components/tapped_search_bar.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:latlong2/latlong.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({
    super.key,
  });

  Widget _buildMapButton(
    BuildContext context, {
    required String heroTag,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      elevation: 2,
      heroTag: heroTag,
      highlightElevation: 3,
      backgroundColor: theme.colorScheme.surface,
      mini: true,
      onPressed: onPressed,
      splashColor: Colors.transparent,
      child: Icon(
        icon,
        color: theme.colorScheme.onSurface,
      ),
    );
  }

  Widget _buildControlButtons(
    BuildContext context,
    MapController mapController,
  ) {
    return PremiumBuilder(
      builder: (context, isPremium) {
        return BlocBuilder<DiscoverCubit, DiscoverState>(
          builder: (context, state) {
            final cubit = context.read<DiscoverCubit>();
            return Positioned(
              bottom: 110 + 10,
              right: 10,
              child: Column(
                children: [
                  // const OverlayChanger(),
                  _buildMapButton(
                    context,
                    heroTag: 'map_overlay',
                    icon: Icons.layers,
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        showDragHandle: true,
                        builder: (context) {
                          return SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 8,
                                    ),
                                    child: Text(
                                      'choose map',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            cubit.onMapOverlayChange(
                                              MapOverlay.venues,
                                            );
                                            context.pop();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                width: state.mapOverlay == MapOverlay.venues
                                                    ? 3
                                                    : 0,
                                                color: state.mapOverlay == MapOverlay.venues
                                                    ? Colors.blue
                                                    : Colors.grey,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: double.infinity,
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(15),
                                                      topRight: Radius.circular(15),
                                                    ),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/layers/venue_markers.png',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  child: Text(
                                                    'venues',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            cubit.onMapOverlayChange(
                                              MapOverlay.opportunities,
                                            );
                                            context.pop();
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              border: Border.all(
                                                width: state.mapOverlay == MapOverlay.opportunities
                                                    ? 3
                                                    : 0,
                                                color: state.mapOverlay == MapOverlay.opportunities
                                                    ? Colors.blue
                                                    : Colors.grey,
                                              ),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: 100,
                                                  width: double.infinity,
                                                  decoration: const BoxDecoration(
                                                    borderRadius: BorderRadius.only(
                                                      topLeft: Radius.circular(15),
                                                      topRight: Radius.circular(15),
                                                    ),
                                                    image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        'assets/layers/op_markers.png',
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 6,
                                                  ),
                                                  child: Text(
                                                    'gigs',
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                      );
                    },
                  ),
                  if (state.mapOverlay == MapOverlay.venues)
                    _buildMapButton(
                      context,
                      icon: Icons.settings,
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          showDragHandle: true,
                          builder: (context) {
                            return MapSettings(
                              genreFilters: isPremium ? state.genreFilters : [],
                              onConfirmGenreSelection: (genres) {
                                if (!isPremium) {
                                  context.push(PaywallPage());
                                  return;
                                }

                                cubit.setGenreFilters(
                                  genres.whereType<Genre>().toList(),
                                );
                              },
                              initialRange:
                                  isPremium ? state.capacityRange : null,
                              onCapacityRangeChange: (ranges) {
                                if (!isPremium) {
                                  context.push(PaywallPage());
                                  return;
                                }

                                cubit.updateCapacityRange(ranges);
                              },
                            );
                          },
                        );
                      },
                      heroTag: 'map_settings',
                    ),
                  _buildMapButton(
                    context,
                    icon: CupertinoIcons.location,
                    onPressed: () {
                      FirebaseAnalytics.instance.logEvent(
                        name: 'discover_seek_home',
                      );

                      mapController.move(
                        LatLng(state.userLat, state.userLng),
                        13,
                      );
                    },
                    heroTag: 'seek-home',
                  ),
                  if (kDebugMode)
                    _buildMapButton(
                      context,
                      icon: Icons.add,
                      onPressed: () {
                        mapController.move(
                          mapController.camera.center,
                          mapController.camera.zoom + 1,
                        );
                      },
                      heroTag: 'zoom-in',
                    ),
                  if (kDebugMode)
                    _buildMapButton(
                      context,
                      icon: Icons.remove,
                      onPressed: () {
                        mapController.move(
                          mapController.camera.center,
                          mapController.camera.zoom - 1,
                        );
                      },
                      heroTag: 'zoom-out',
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPremiumBanner(BuildContext context) {
    return PremiumBuilder(
      builder: (context, isPremium) {
        if (isPremium) {
          return const SizedBox();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              gradient: LinearGradient(
                colors: [
                  Colors.red.shade800.withOpacity(0.8),
                  Colors.pink.withOpacity(0.8),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  const Icon(
                    Icons.star,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'try tapped premium to increase your chances of getting booked!',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      context.push(PaywallPage());
                    },
                    child: const Text(
                      'upgrade',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mapController = MapController();
    final streamClient = StreamChat.of(context).client;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return PremiumBuilder(
          builder: (context, isPremium) {
            final initGenres = isPremium
                ? currentUser.performerInfo
                    .map((info) => info.genres)
                    .getOrElse(() => [])
                : <String>[];
            return BlocProvider<DiscoverCubit>(
              create: (context) => DiscoverCubit(
                currentUser: currentUser,
                database: context.database,
                search: context.read<SearchRepository>(),
                initGenres: fromStrings(initGenres),
                onboardingBloc: context.read<OnboardingBloc>(),
                places: context.places,
                suggestedMaxCapacity: isPremium
                    ? currentUser.performerInfo
                        .map((info) => info.category.suggestedMaxCapacity)
                        .getOrElse(() => 1000)
                    : 1000,
              ),
              child: Scaffold(
                body: LayoutBuilder(
                  builder: (context, contains) {
                    return Stack(
                      children: [
                        MapBase(
                          mapController: mapController,
                        ),
                        _buildControlButtons(context, mapController),
                        SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Expanded(
                                      child: TappedSearchBar(
                                        trailing: [],
                                      ),
                                    ),
                                    StreamBuilder<int?>(
                                      stream: streamClient
                                          .on()
                                          .where(
                                            (event) =>
                                                event.totalUnreadCount != null,
                                          )
                                          .map(
                                            (event) => event.totalUnreadCount,
                                          ),
                                      initialData:
                                          streamClient.state.totalUnreadCount,
                                      builder: (context, snapshot) {
                                        final unreadMessagesCount =
                                            snapshot.data ?? 0;

                                        return Card(
                                          color: theme.colorScheme.surface,
                                          elevation: 0,
                                          shape: const CircleBorder(),
                                          child: IconButton(
                                            onPressed: () => context.push(
                                              MessagingChannelListPage(),
                                            ),
                                            icon: badges.Badge(
                                              showBadge:
                                                  unreadMessagesCount > 0,
                                              badgeContent: Text(
                                                unreadMessagesCount.toString(),
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme.onSurface,
                                                ),
                                              ),
                                              position:
                                                  badges.BadgePosition.topEnd(),
                                              child: Icon(
                                                CupertinoIcons
                                                    .chat_bubble_text_fill,
                                                color:
                                                    theme.colorScheme.onSurface,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                _buildPremiumBanner(context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                bottomSheet: DraggableSheet(),
              ),
            );
          },
        );
      },
    );
  }
}
