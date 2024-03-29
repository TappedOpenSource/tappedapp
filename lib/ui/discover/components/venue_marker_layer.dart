import 'dart:math';

import 'package:cached_annotation/cached_annotation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/ui/profile/profile_view.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class VenueMarkerLayer extends StatelessWidget {
  const VenueMarkerLayer({
    super.key,
  });

  @cached
  bool _isVenueGoodFit(UserModel currentUser, UserModel venue) {
    final category = currentUser.performerInfo.map((t) => t.category);
    final userGenres =
        currentUser.performerInfo.map((t) => t.genres).getOrElse(() => []);
    final goodCapFit =
        venue.venueInfo.flatMap((t) => t.capacity).map2(category, (cap, cat) {
      return cat.suggestedMaxCapacity >= cap;
    }).getOrElse(() => false);
    final genreFit = venue.venueInfo.map((t) {
      final one = Set<String>.from(t.genres.map((e) => e.toLowerCase()));
      final two = Set<String>.from(userGenres.map((e) => e.toLowerCase()));
      final intersect = one.intersection(two);
      return intersect.isNotEmpty;
    }).getOrElse(() => false);
    final isGoodFit = goodCapFit && genreFit;

    return isGoodFit;
  }

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.compact(locale: 'en');
    return CurrentUserBuilder(
      builder: (context, currentUser) {
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
                    final isGoodFit = _isVenueGoodFit(
                      currentUser,
                      venue,
                    );
                    return switch (venue.location) {
                      None() => null,
                      Some(:final value) => Marker(
                          width: 100,
                          height: 100,
                          point: LatLng(value.lat, value.lng),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showCupertinoModalBottomSheet<void>(
                                    context: context,
                                    builder: (context) {
                                      return ProfileView(
                                        visitedUserId: venue.id,
                                        visitedUser: Option.of(venue),
                                      );
                                    },
                                  );
                                },
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
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: isGoodFit
                                                      ? Colors.green
                                                      : Colors.red,
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
      },
    );
  }
}
