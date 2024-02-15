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
import 'package:latlong2/latlong.dart';

class VenueClusterLayer extends StatelessWidget {
  const VenueClusterLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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
                    width: 80,
                    height: 80,
                    point: LatLng(value.lat, value.lng),
                    child: GestureDetector(
                      onTap: () =>
                          context.push(
                            ProfilePage(
                              userId: venue.id,
                              user: Option.of(venue),
                            ),
                          ),
                      child: UserAvatar(
                        imageUrl: venue.profilePicture,
                        radius: 20,
                      ),
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
              final clusterKey =
                  'map-badge-$index-len-${markers.length}';

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
