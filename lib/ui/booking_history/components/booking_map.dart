import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_tile_caching/flutter_map_tile_caching.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/ui/app_theme_cubit.dart';
import 'package:intheloopapp/ui/booking_history/booking_history_cubit.dart';
import 'package:intheloopapp/ui/discover/components/bookings_marker_layer.dart';
import 'package:intheloopapp/ui/discover/components/bookings_polygon_layer.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

const defaultMapboxToken =
    'pk.eyJ1Ijoiam9uYXlsb3I4OSIsImEiOiJjbHJvNGdsemswNjl3MnFtdHNieXEyaWphIn0.gwc31X7uTzjxeDm6vcGzCg';
const mapboxDarkStyle = 'mapbox/dark-v11';
const mapboxLightStyle = 'mapbox/light-v10';

class BookingMap extends StatelessWidget {
  const BookingMap({
    required this.mapController,
    super.key,
  });

  final MapController mapController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
      builder: (context, state) {
        return FlutterMap(
          mapController: mapController,
          options: MapOptions(
            // minZoom: 10,
            maxZoom: 18,
            initialZoom: 3,
            initialCenter: LatLng(Location.nyc.lat, Location.nyc.lng),
            // onPositionChanged: (position, hasGesture) {
            //   context.read<DiscoverCubit>().onBoundsChange(
            //     position.bounds,
            //   );
            // },
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
            BookingsPolygonLayer(bookings: state.bookings),
            BookingsMarkerLayer(
              bookings: state.bookings,
              showFliers: state.showFlierMarkers,
            ),
            RichAttributionWidget(
              animationConfig: const ScaleRAWA(),
              // Or `FadeRAWA` as is default
              showFlutterMapAttribution: false,
              attributions: [
                TextSourceAttribution(
                  'OpenStreetMap contributors',
                  onTap: () => launchUrl(
                    Uri.parse(
                      'https://openstreetmap.org/copyright',
                    ),
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
