import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/discover/components/draggable_sheet.dart';
import 'package:intheloopapp/ui/discover/components/map_base.dart';
import 'package:intheloopapp/ui/discover/components/map_config_slider.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:latlong2/latlong.dart';

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
      backgroundColor: theme.colorScheme.background,
      mini: true,
      onPressed: onPressed,
      splashColor: Colors.transparent,
      child: Icon(
        icon,
        color: theme.colorScheme.onBackground,
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
              bottom: 100 + 10,
              right: 10,
              child: Column(
                children: [
                  _buildMapButton(
                    context,
                    icon: CupertinoIcons.location,
                    onPressed: () {
                      mapController.move(
                        LatLng(state.userLat, state.userLng),
                        13,
                      );
                    },
                    heroTag: 'seek-home',
                  ),
                  _buildMapButton(
                    context,
                    icon: Icons.layers,
                    onPressed: () {
                      showModalBottomSheet<void>(
                        context: context,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            child: MapConfigSlider(
                              initialOverlay: state.mapOverlay,
                              onChange: (overlay, premiumOnly) {
                                if (premiumOnly && !isPremium) {
                                  context.push(PaywallPage());
                                  return;
                                }

                                cubit.onMapOverlayChange(
                                      overlay,
                                    );
                              },
                            ),
                          );
                        },
                      );
                    },
                    heroTag: 'overlay',
                  ),
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

  Widget _buildGenreFilterButton(
    BuildContext context, {
    required Genre genre,
  }) {
    final theme = Theme.of(context);
    return PremiumBuilder(
      builder: (context, isPremium) {
        return BlocBuilder<DiscoverCubit, DiscoverState>(
          builder: (context, state) {
            final selected = state.genreFilters.contains(genre);
            return InkWell(
              onTap: () {
                if (!isPremium) {
                  context.push(PaywallPage());
                  return;
                }

                context.read<DiscoverCubit>().toggleGenreFilter(genre);
              },
              child: Card(
                color: selected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.surface,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.music_note_rounded,
                        size: 12,
                      ),
                      const SizedBox(
                        width: 6,
                      ),
                      Text(
                        genre.formattedName,
                        style: TextStyle(
                          color: selected
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  List<Widget> _buildGenreFilterButtons(
    BuildContext context, {
    required List<Genre> genreFilters,
  }) {
    final genres = List<Genre>.from(Genre.values)
      ..sort(
        (a, b) {
          final containsA = genreFilters.contains(a) ? 1 : 0;
          final containsB = genreFilters.contains(b) ? 1 : 0;
          return containsB - containsA;
        },
      );
    return genres
        .map(
          (Genre e) => _buildGenreFilterButton(
            context,
            genre: e,
          ),
        )
        .toList();
  }

  Widget _buildGenreList(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _buildGenreFilterButtons(
              context,
              genreFilters: state.genreFilters,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
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
                search: context.read<SearchRepository>(),
                initGenres: fromStrings(initGenres),
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
                                    Expanded(
                                      child: InkWell(
                                        onTap: () => context.push(
                                          GigSearchInitPage(),
                                        ),
                                        child: Card(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () => context.push(
                                                  GigSearchInitPage(),
                                                ),
                                                icon: const Icon(Icons.search),
                                              ),
                                              const Expanded(
                                                child: Text('get booked...'),
                                              ),
                                              // const NotificationIconButton(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    // const NotificationIconButton(),
                                  ],
                                ),
                                _buildGenreList(context),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                bottomSheet: const DraggableSheet(),
              ),
            );
          },
        );
      },
    );
  }
}
