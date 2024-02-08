import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:latlong2/latlong.dart';

class ClusterLayer extends StatelessWidget {
  const ClusterLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const defaultLoc = Location.rva;
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
              ...state.hits.map((venue) {
                final loc =
                venue.location.getOrElse(() => defaultLoc);
                return Marker(
                  width: 80,
                  height: 80,
                  point: LatLng(loc.lat, loc.lng),
                  child: GestureDetector(
                    onTap: () =>
                        context.push(
                          ProfilePage(
                            userId: venue.id,
                            user: Option.of(venue),
                          ),
                        ),
                    child: UserAvatar(
                      imageUrl: venue.profilePicture.toNullable(),
                      radius: 20,
                    ),
                  ),
                );
              }),
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
