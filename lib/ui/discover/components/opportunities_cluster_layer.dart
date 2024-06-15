import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
              final theme = Theme.of(context);
              return FloatingActionButton(
                onPressed: () {
                  // push page to select opportunities
                  showCupertinoModalBottomSheet<void>(
                    context: context,
                    builder: (context) {
                      return Scaffold(
                        appBar: AppBar(
                          leading: SizedBox.shrink(),
                          actions: const [],
                          bottom: PreferredSize(
                            preferredSize: const Size.fromHeight(50),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        // value: state.allSelected,
                                        value: false,
                                        onChanged: (selected) {
                                          // context.read<GigSearchCubit>().selectAll(
                                          //   selected ?? false,
                                          // );
                                        },
                                      ),
                                      const SizedBox(width: 4),
                                      const Text('Select All'),
                                    ],
                                  ),
                                  Text(
                                    'Found ${markers.length} venues',
                                    style: theme.textTheme.titleMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        body: ListView(
                          children: markers.map(
                            (marker) {
                              final op = state.opportunityHits.firstWhere(
                                (opportunity) =>
                                    opportunity.location.lat ==
                                        marker.point.latitude &&
                                    opportunity.location.lng ==
                                        marker.point.longitude,
                              );
                              final startTime = DateFormat(
                                      DateFormat.YEAR_ABBR_MONTH_WEEKDAY_DAY)
                                  .format(op.startTime);
                              return ListTile(
                                leading: switch (op.flierUrl) {
                                  None() => const Icon(Icons.image_not_supported),
                                  Some(:final value) => CachedNetworkImage(
                                      imageUrl: value,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                },
                                title: Text(
                                  op.title,
                                  style: theme.textTheme.titleMedium,
                                ),
                                subtitle: Text(
                                  startTime,
                                ),
                                trailing: Checkbox(
                                  value: false,
                                  // value: selectableResult.selected,
                                  onChanged: (selected) {
                                    // context.read<GigSearchCubit>().updateSelected(
                                    //   venue.id,
                                    //   selected ?? false,
                                    // );
                                  },
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      );
                    },
                  );
                },
                child: const Icon(Icons.attach_money),
                backgroundColor: Colors.green,
              );
            },
          ),
        );
      },
    );
  }
}
