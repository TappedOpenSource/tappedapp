import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/discover/components/draggable_sheet.dart';
import 'package:intheloopapp/ui/discover/components/map_base.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/ui/profile/components/notification_icon_button.dart';
import 'package:latlong2/latlong.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({
    super.key,
  });

  Widget _buildMapButton(
    BuildContext context, {
    required String heroTag,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return FloatingActionButton(
      elevation: 2,
      heroTag: heroTag,
      highlightElevation: 3,
      backgroundColor: theme.colorScheme.background,
      mini: true,
      onPressed: onPressed,
      splashColor: Colors.transparent,
      child: Icon(
        icon,
        color: theme.colorScheme.onBackground,
      ),
    );
  }

  Widget _buildControlButtons(
    BuildContext context,
    MapController mapController,
  ) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        return Positioned(
          bottom: 100 + 10,
          right: 10,
          child: Column(
            children: [
              _buildMapButton(
                context,
                icon: CupertinoIcons.location,
                onPressed: () {
                  mapController.move(
                    LatLng(state.userLat, state.userLng),
                    13,
                  );
                },
                heroTag: 'seek-home',
              ),
              _buildMapButton(
                context,
                icon: Icons.add,
                onPressed: () {
                  mapController.move(
                    mapController.camera.center,
                    mapController.camera.zoom + 1,
                  );
                },
                heroTag: 'zoom-in',
              ),
              _buildMapButton(
                context,
                icon: Icons.remove,
                onPressed: () {
                  mapController.move(
                    mapController.camera.center,
                    mapController.camera.zoom - 1,
                  );
                },
                heroTag: 'zoom-out',
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mapController = MapController();
    return BlocProvider<DiscoverCubit>(
      create: (context) => DiscoverCubit(
        search: context.read<SearchRepository>(),
      ),
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, contains) {
            return Stack(
              children: [
                MapBase(
                  mapController: mapController,
                ),
                _buildControlButtons(context, mapController),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: () => context.push(
                              GigSearchInitPage(),
                            ),
                            child: Card(
                              child: Row(
                                children: [
                                  IconButton(
                                    onPressed: () => context.push(
                                      GigSearchInitPage(),
                                    ),
                                    icon: const Icon(Icons.search),
                                  ),
                                  const Expanded(
                                    child: Text('get booked...'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const NotificationIconButton(),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        bottomSheet: const DraggableSheet(),
      ),
    );
  }
}
