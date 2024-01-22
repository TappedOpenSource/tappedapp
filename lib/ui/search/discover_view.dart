import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:intheloopapp/domains/models/location.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/search/components/venue_card.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:latlong2/latlong.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:url_launcher/url_launcher.dart';

const defaultMapboxToken =
    'pk.eyJ1Ijoiam9uYXlsb3I4OSIsImEiOiJjbHJvNGdsemswNjl3MnFtdHNieXEyaWphIn0.gwc31X7uTzjxeDm6vcGzCg';
const mapboxStyle = 'mapbox/dark-v11';

class DiscoverView extends StatelessWidget {
  const DiscoverView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final defaultLoc = Location.rva();
    final database = context.database;
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
                    options: MapOptions(
                      minZoom: 10,
                      maxZoom: 18,
                      initialCenter: LatLng(defaultLoc.lat, defaultLoc.lng),
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
                          size: Size(40, 40),
                          markers: [
                            ...rvaVenues.map((venue) {
                              final loc = venue.location.unwrapOr(defaultLoc);
                              return Marker(
                                width: 80,
                                height: 80,
                                point: LatLng(loc.lat, loc.lng),
                                child: Container(
                                  child: Icon(
                                    Icons.location_on,
                                    color: tappedAccent,
                                  ),
                                ),
                              );
                            }),
                          ],
                          polygonOptions: PolygonOptions(
                            borderColor: tappedAccent,
                            color: tappedAccent.withOpacity(0.5),
                            borderStrokeWidth: 3,
                          ),
                          builder: (context, markers) {
                            return FloatingActionButton(
                              heroTag: 'mapMarkerCluster-${markers.length}',
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
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                      child: Hero(
                        tag: 'searchBar',
                        child: SearchBar(
                          hintText: 'Search...',
                          leading: IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.search),
                          ),
                          onTap: () {
                            context.push(
                              SearchPage(),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          bottomSheet: DraggableScrollableSheet(
            expand: false,
            maxChildSize: 0.9,
            builder: (ctx, scrollController) => SizedBox(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DraggableHeader(
                      scrollController: scrollController,
                      bottomSheetDraggableAreaHeight: 32,
                    ),
                    const Text(
                      'Top Richmond Venues',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: SizedBox(
                        height: 200,
                        child: ScrollSnapList(
                          onItemFocus: (index) {},
                          selectedItemAnchor: SelectedItemAnchor.START,
                          itemCount: rvaVenues.length,
                          itemSize: 150 + (8 * 2),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: VenueCard(venue: rvaVenues[index]),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
    Key? key,
    required this.scrollController,
    required this.bottomSheetDraggableAreaHeight,
  }) : super(key: key);
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
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
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(2)),
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
