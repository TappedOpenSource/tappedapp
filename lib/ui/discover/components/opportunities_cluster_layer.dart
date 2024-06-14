import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:latlong2/latlong.dart';

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
                    child: const Icon(
                      Icons.location_on,
                      color: Colors.red,
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
                },
                child: const Icon(Icons.location_on),
                backgroundColor: Colors.green,
              );
            },
          ),
        );
      },
    );
  }
}
