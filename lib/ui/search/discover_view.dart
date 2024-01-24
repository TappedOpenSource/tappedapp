import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/components/notification_icon_button.dart';
import 'package:intheloopapp/ui/search/components/venue_card.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/ui/user_card.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/debouncer.dart';
import 'package:latlong2/latlong.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:url_launcher/url_launcher.dart';

const defaultMapboxToken =
    'pk.eyJ1Ijoiam9uYXlsb3I4OSIsImEiOiJjbHJvNGdsemswNjl3MnFtdHNieXEyaWphIn0.gwc31X7uTzjxeDm6vcGzCg';
const mapboxStyle = 'mapbox/dark-v11';

class DiscoverView extends StatelessWidget {
  DiscoverView({
    super.key,
  });

  final _debouncer = Debouncer(
    const Duration(milliseconds: 300),
    executionInterval: const Duration(milliseconds: 750),
  );

  void onChange(LatLngBounds? bounds) {
    _debouncer.run(
      () async {
        // updateVisibleImages(bounds);
      },
    );
  }

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

  Widget _userSlider(List<UserModel> users) {
    return SizedBox(
      height: 200,
      child: ScrollSnapList(
        onItemFocus: (index) {},
        selectedItemAnchor: SelectedItemAnchor.START,
        itemCount: users.length,
        itemSize: 150 + (8 * 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: UserCard(user: users[index]),
          );
        },
      ),
    );
  }

  Widget _venueSlider(List<UserModel> venues) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: SizedBox(
        height: 200,
        child: ScrollSnapList(
          onItemFocus: (index) {},
          selectedItemAnchor: SelectedItemAnchor.START,
          itemCount: venues.length,
          itemSize: 150 + (8 * 2),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: VenueCard(venue: venues[index]),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultLoc = Location.rva();
    final database = context.database;
    final mapController = MapController();
    return FutureBuilder(
      future: database.getRichmondVenues(),
      builder: (context, snapshot) {
        final rvaVenues = snapshot.data ?? [];
        return Scaffold(
          body: LayoutBuilder(
            builder: (context, contains) {
              return Stack(
                children: [
                  FlutterMap(
                    mapController: mapController,
                    options: MapOptions(
                      minZoom: 10,
                      maxZoom: 18,
                      initialCenter: LatLng(defaultLoc.lat, defaultLoc.lng),
                      onPositionChanged: (position, hasGesture) {
                        onChange(position.bounds);
                      },
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
                        additionalOptions: const {
                          'accessToken': defaultMapboxToken,
                          'id': mapboxStyle,
                        },
                      ),
                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          maxClusterRadius: 40,
                          size: const Size(40, 40),
                          polygonOptions: PolygonOptions(
                            borderColor: tappedAccent,
                            color: tappedAccent.withOpacity(0.5),
                            borderStrokeWidth: 3,
                          ),
                          markers: [
                            ...rvaVenues.map((venue) {
                              final loc = venue.location.unwrapOr(defaultLoc);
                              return Marker(
                                width: 80,
                                height: 80,
                                point: LatLng(loc.lat, loc.lng),
                                child: GestureDetector(
                                  onTap: () => context.push(
                                    ProfilePage(
                                      userId: venue.id,
                                      user: Some(venue),
                                    ),
                                  ),
                                  child: UserAvatar(
                                    imageUrl: venue.profilePicture.asNullable(),
                                    radius: 20,
                                  ),
                                ),
                              );
                            }),
                          ],
                          builder: (context, markers) {
                            final index = markers.first.key
                                .toString()
                                .replaceAll(RegExp('[^0-9]'), '');
                            final clusterKey =
                                'map-badge-$index-len-${markers.length}';

                            return FloatingActionButton(
                              heroTag: clusterKey,
                              onPressed: null,
                              child: Text(markers.length.toString()),
                            );
                          },
                        ),
                      ),
                      RichAttributionWidget(
                        animationConfig: const ScaleRAWA(),
                        // Or `FadeRAWA` as is default
                        showFlutterMapAttribution: false,
                        attributions: [
                          TextSourceAttribution(
                            'OpenStreetMap contributors',
                            onTap: () => launchUrl(
                              Uri.parse('https://openstreetmap.org/copyright'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 100 + 10,
                    right: 10,
                    child: Column(
                      children: [
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
                  ),
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
                                GigSearchPage(),
                              ),
                              child: Card(
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: () => context.push(
                                        GigSearchPage(),
                                      ),
                                      icon: const Icon(Icons.search),
                                    ),
                                    const Expanded(
                                      child: Text('show time...'),
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
          bottomSheet: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.2,
            maxChildSize: 0.9,
            minChildSize: 0.1,
            snap: true,
            snapSizes: const [0.1, 0.2, 0.5, 0.9],
            builder: (ctx, scrollController) => ColoredBox(
              color: Theme.of(context).colorScheme.background,
              child: Column(
                children: [
                  DraggableHeader(
                    scrollController: scrollController,
                    bottomSheetDraggableAreaHeight: 32,
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Top Richmond Venues',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _venueSlider(rvaVenues),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            child: Text(
                              'Top Bookers',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: database.getBookerLeaders(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }

                              final bookerLeaders = snapshot.data ?? [];
                              return _userSlider(bookerLeaders);
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            child: Text(
                              'Top DC Venues',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: database.getDCVenues(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }

                              final dcVenues = snapshot.data ?? [];
                              return _venueSlider(dcVenues);
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            child: Text(
                              'Top NoVa Venues',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: database.getNovaVenues(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }

                              final novaVenues = snapshot.data ?? [];
                              return _venueSlider(novaVenues);
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            child: Text(
                              'Top Maryland Venues',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: database.getMarylandVenues(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }

                              final marylandVenues = snapshot.data ?? [];
                              return _venueSlider(marylandVenues);
                            },
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 8,
                            ),
                            child: Text(
                              'Top Performers',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          FutureBuilder(
                            future: database.getBookingLeaders(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }

                              final bookingLeaders = snapshot.data ?? [];
                              return _userSlider(bookingLeaders);
                            },
                          ),
                          const SizedBox(
                            height: 100,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class DraggableHeader extends StatelessWidget {
  const DraggableHeader({
    required this.scrollController,
    required this.bottomSheetDraggableAreaHeight,
    super.key,
  });

  static const indicatorHeight = 4.0;
  final ScrollController scrollController;
  final double bottomSheetDraggableAreaHeight;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      controller: scrollController,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12),
          ),
          color: Colors.white.withOpacity(0.1),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical:
                  bottomSheetDraggableAreaHeight / 2 - indicatorHeight / 2,
            ),
            child: Container(
              height: indicatorHeight,
              width: 72,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
