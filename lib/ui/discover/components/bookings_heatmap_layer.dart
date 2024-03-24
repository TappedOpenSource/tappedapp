import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';

class BookingsHeatmapLayer extends StatelessWidget {
  BookingsHeatmapLayer({
    super.key,
  });

  final gradients = [
    // HeatMapOptions.defaultGradient,
    {
      0.25: Colors.blue,
      0.55: Colors.red,
      0.85: Colors.pink,
      1.0: Colors.purple,
    }
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        if (state.bookingHits.isEmpty) {
          return const SizedBox.shrink();
        }

        return HeatMapLayer(
          heatMapDataSource: InMemoryHeatMapDataSource(
            data: state.weightedBookingLatLngs,
          ),
          heatMapOptions: HeatMapOptions(
            gradient: gradients[0],
            minOpacity: 0.1,
          ),
          // reset: _rebuildStream.stream,
        );
      },
    );
  }
}
