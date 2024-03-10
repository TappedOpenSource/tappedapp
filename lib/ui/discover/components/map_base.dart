import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/discover/components/bookings_heatmap_layer.dart';
import 'package:intheloopapp/ui/discover/components/opportunities_heatmap_layer.dart';
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

        final (lat, lng) =
            snapshot.data ?? (Location.nyc.lat, Location.nyc.lng);
        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            // minZoom: 10,
            maxZoom: 18,
            initialCenter: LatLng(lat, lng),
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
            BlocBuilder<DiscoverCubit, DiscoverState>(
              builder: (context, state) {
                return switch (state.mapOverlay) {
                  MapOverlay.venues => const VenueMarkerLayer(),
                  MapOverlay.bookings => BookingsHeatmapLayer(),
                  MapOverlay.opportunities => const OpportunitiesHeatmapLayer(),
                };
              },
            ),
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
}
