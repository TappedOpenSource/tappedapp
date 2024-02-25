import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeago/timeago.dart';

class VenueMarkerLayer extends StatelessWidget {
  const VenueMarkerLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.compact(locale: 'en');
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        return MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 40,
            size: const Size(40, 40),
            // polygonOptions: PolygonOptions(
            //   borderColor: tappedAccent,
            //   color: tappedAccent.withOpacity(0.5),
            //   borderStrokeWidth: 3,
            // ),
            markers: [
              ...state.venueHits.map((venue) {
                return switch (venue.location) {
                  None() => null,
                  Some(:final value) => Marker(
                      width: 100,
                      height: 100,
                      point: LatLng(value.lat, value.lng),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => context.push(
                              ProfilePage(
                                userId: venue.id,
                                user: Option.of(venue),
                              ),
                            ),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 6,
                                ),
                                child: Row(
                                  children: [
                                    UserAvatar(
                                      pushUser: Option.of(venue),
                                      pushId: Option.of(venue.id),
                                      imageUrl: venue.profilePicture,
                                      radius: 10,
                                    ),
                                    switch (venue.venueInfo
                                        .flatMap((t) => t.capacity)) {
                                      None() => const SizedBox.shrink(),
                                      Some(:final value) => Padding(
                                        padding: const EdgeInsets.only(
                                          left: 5,
                                        ),
                                        child: Text(
                                            formatter.format(value),
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                      ),
                                    },
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                };
              }).whereType<Marker>(),
            ],
            builder: (context, markers) {
              // random int
              final random = Random().nextInt(999).toString();
              final index = markers.first.key
                  .toString()
                  .replaceAll(RegExp('[^0-9]'), random);
              final clusterKey = 'map-badge-$index-len-${markers.length}';

              return FloatingActionButton(
                heroTag: clusterKey,
                onPressed: null,
                child: Text(markers.length.toString()),
              );
            },
          ),
        );
      },
    );
  }
}
