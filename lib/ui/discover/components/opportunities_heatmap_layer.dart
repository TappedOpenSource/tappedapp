import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map_heatmap/flutter_map_heatmap.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';

class OpportunitiesHeatmapLayer extends StatelessWidget {
  const OpportunitiesHeatmapLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        if (state.opportunityHits.isEmpty) {
          return const SizedBox.shrink();
        }

        return HeatMapLayer(
          heatMapDataSource: InMemoryHeatMapDataSource(
            data: state.weightedOpportunityLatLngs,
          ),
          heatMapOptions: HeatMapOptions(
            gradient: HeatMapOptions.defaultGradient,
            minOpacity: 0.1,
          ),
          // reset: _rebuildStream.stream,
        );
      },
    );
  }
}
