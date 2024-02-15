import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/discover/components/bookings_heatmap_layer.dart';
import 'package:intheloopapp/ui/discover/components/opportunities_heatmap_layer.dart';
import 'package:intheloopapp/ui/discover/components/venue_marker_layer.dart';
import 'package:intheloopapp/ui/discover/components/draggable_sheet.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/ui/profile/components/notification_icon_button.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

const defaultMapboxToken =
    'pk.eyJ1Ijoiam9uYXlsb3I4OSIsImEiOiJjbHJvNGdsemswNjl3MnFtdHNieXEyaWphIn0.gwc31X7uTzjxeDm6vcGzCg';
const mapboxDarkStyle = 'mapbox/dark-v11';
const mapboxLightStyle = 'mapbox/light-v10';

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

  Widget _buildMap(
    BuildContext context,
    MapController mapController,
  ) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            // minZoom: 10,
            maxZoom: 18,
            initialCenter: LatLng(state.userLat, state.userLng),
            onPositionChanged: (position, hasGesture) {
              context.read<DiscoverCubit>().onBoundsChange(
                    position.bounds,
                  );
            },
          ),
          children: [
            BlocBuilder<AppThemeCubit, bool>(
              builder: (context, isDark) {
                final theme = isDark ? mapboxDarkStyle : mapboxLightStyle;
                return TileLayer(
                  urlTemplate:
                      'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                  additionalOptions: {
                    'accessToken': defaultMapboxToken,
                    'id': theme,
                  },
                  tileProvider: FMTC.instance('mapStore').getTileProvider(),
                );
              },
            ),
            switch (state.mapOverlay) {
              MapOverlay.venues => const VenueMarkerLayer(),
              MapOverlay.bookings => BookingsHeatmapLayer(),
              MapOverlay.opportunities => const OpportunitiesHeatmapLayer(),
            },
            RichAttributionWidget(
              animationConfig: const ScaleRAWA(),
              // Or `FadeRAWA` as is default
              showFlutterMapAttribution: false,
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                    Uri.parse('https://openstreetmap.org/copyright'),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _buildControlButtons(
    BuildContext context,
    MapController mapController,
  ) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
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
  }

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    return BlocProvider<DiscoverCubit>(
      create: (context) => DiscoverCubit(
        search: context.read<SearchRepository>(),
      )..initLocation(),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, contains) {
            return Stack(
              children: [
                _buildMap(context, mapController),
                _buildControlButtons(context, mapController),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
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
                                ],
                              ),
                            ),
                          ),
                        ),
                        const NotificationIconButton(),
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
  }
}
