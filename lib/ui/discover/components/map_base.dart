import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/discover/components/bookings_heatmap_layer.dart';
import 'package:intheloopapp/ui/discover/components/bookings_marker_layer.dart';
import 'package:intheloopapp/ui/discover/components/bookings_polygon_layer.dart';
import 'package:intheloopapp/ui/discover/components/current_location_layer.dart';
import 'package:intheloopapp/ui/discover/components/opportunities_cluster_layer.dart';
import 'package:intheloopapp/ui/discover/components/venue_marker_layer.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

const defaultMapboxToken =
    'pk.eyJ1Ijoiam9uYXlsb3I4OSIsImEiOiJjbHJvNGdsemswNjl3MnFtdHNieXEyaWphIn0.gwc31X7uTzjxeDm6vcGzCg';
const mapboxDarkStyle = 'mapbox/dark-v11';
const mapboxLightStyle = 'mapbox/light-v10';

class MapBase extends StatelessWidget {
  const MapBase({
    required this.mapController,
    super.key,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: context.read<DiscoverCubit>().initLocation(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        final data = snapshot.data;

        return switch (data) {
          null => const Center(
              child: CupertinoActivityIndicator(),
            ),
          (double(), double()) => BlocBuilder<DiscoverCubit, DiscoverState>(
              builder: (context, state) {
                return FlutterMap(
                  mapController: mapController,
                  options: MapOptions(
                    // minZoom: 10,
                    maxZoom: 18,
                    initialZoom: 6,
                    initialCenter: LatLng(data.$1, data.$2),
                    onPositionChanged: (position, hasGesture) {
                      context.read<DiscoverCubit>().onBoundsChange(
                            position.bounds,
                          );
                    },
                  ),
                  children: [
                    BlocBuilder<AppThemeCubit, bool>(
                      builder: (context, isDark) {
                        final theme =
                            isDark ? mapboxDarkStyle : mapboxLightStyle;
                        return TileLayer(
                          urlTemplate:
                              'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                          additionalOptions: {
                            'accessToken': defaultMapboxToken,
                            'id': theme,
                          },
                          tileProvider: const FMTCStore('mapStore')
                              .getTileProvider(),
                        );
                      },
                    ),
                    ...switch (state.mapOverlay) {
                      MapOverlay.venues => [
                          const VenueMarkerLayer(),
                        ],
                      // MapOverlay.userBookings => [
                        //   BookingsPolygonLayer(
                        //     bookings: state.userBookings,
                        //   ),
                        //   BookingsMarkerLayer(
                        //     bookings: state.userBookings,
                        //     showFliers: true,
                        //   ),
                        // ],
                      // MapOverlay.bookings => [
                      //     BookingsHeatmapLayer(),
                      //   ],
                      MapOverlay.opportunities => [
                          const OpportunitiesClusterLayer(),
                        ],
                    },
                    const CurrentLocationLayer(),
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
            ),
        };
      },
    );
  }
}
