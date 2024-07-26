import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/ui/opportunities/opportunities_results_view.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:uuid/uuid.dart';

class OpportunitiesClusterLayer extends StatelessWidget {
  const OpportunitiesClusterLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        if (state.opportunityHits.isEmpty) {
          return const SizedBox.shrink();
        }

        return MarkerClusterLayerWidget(
          options: MarkerClusterLayerOptions(
            maxClusterRadius: 120,
            size: const Size(40, 40),
            markers: state.opportunityHits
                .map(
                  (opportunity) => Marker(
                    width: 40,
                    height: 40,
                    point: LatLng(
                      opportunity.location.lat,
                      opportunity.location.lng,
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        // push page to select opportunities
                        showCupertinoModalBottomSheet<void>(
                          context: context,
                          builder: (context) {
                            return OpportunitiesResultsView(
                              ops: [opportunity],
                            );
                          },
                        );
                      },
                      heroTag: const Uuid().v4(),
                      backgroundColor: Colors.green,
                      child: const Icon(
                        Icons.attach_money,
                      ),
                    ),
                  ),
                )
                .toList(),
            polygonOptions: const PolygonOptions(
              borderColor: Colors.blueAccent,
              color: Colors.black12,
              borderStrokeWidth: 3,
            ),
            builder: (context, markers) {
              return FloatingActionButton(
                onPressed: () {
                  // push page to select opportunities
                  final ops = markers.map(
                    (marker) {
                      return state.opportunityHits.firstWhere(
                        (opportunity) =>
                            opportunity.location.lat == marker.point.latitude &&
                            opportunity.location.lng == marker.point.longitude,
                      );
                    },
                  ).toList()
                    ..sort(
                      (a, b) => a.startTime.compareTo(b.startTime),
                    );
                  showCupertinoModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return OpportunitiesResultsView(ops: ops);
                    },
                  );
                },
                heroTag: const Uuid().v4(),
                backgroundColor: Colors.green,
                child: const Icon(
                  Icons.attach_money,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
