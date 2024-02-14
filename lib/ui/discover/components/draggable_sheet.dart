import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/discover/components/draggable_header.dart';
import 'package:intheloopapp/ui/discover/components/user_slider.dart';
import 'package:intheloopapp/ui/discover/components/venue_slider.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class DraggableSheet extends StatelessWidget {
  const DraggableSheet({super.key});

  Widget _buildMapOverlayButton(
    BuildContext context, {
    required MapOverlay currentOverlay,
    required MapOverlay overlay,
    required String label,
    required ImageProvider image,
  }) {
    final theme = Theme.of(context);
    final isSelected = currentOverlay == overlay;
    return InkWell(
      onTap: () => context.read<DiscoverCubit>().onMapOverlayChange(
            overlay,
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: image,
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? theme.colorScheme.onSurface
                  : theme.colorScheme.onSurface.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocBuilder<DiscoverCubit, DiscoverState>(
          builder: (context, state) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.1,
              minChildSize: 0.1,
              snap: true,
              snapSizes: const [0.1, 0.5, 1],
              builder: (ctx, scrollController) => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(
                  children: [
                    DraggableHeader(
                      scrollController: scrollController,
                      bottomSheetDraggableAreaHeight: 32,
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 150,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  _buildMapOverlayButton(
                                    context,
                                    currentOverlay: state.mapOverlay,
                                    overlay: MapOverlay.venues,
                                    label: 'Venues',
                                    image: AssetImage(
                                      'assets/layers/venue_markers.png',
                                    ) as ImageProvider,
                                  ),
                                  _buildMapOverlayButton(
                                    context,
                                    currentOverlay: state.mapOverlay,
                                    overlay: MapOverlay.bookings,
                                    label: 'Bookings',
                                    image: AssetImage(
                                      'assets/layers/booking_heatmap.png',
                                    ) as ImageProvider,
                                  ),
                                  _buildMapOverlayButton(
                                    context,
                                    currentOverlay: state.mapOverlay,
                                    overlay: MapOverlay.opportunities,
                                    label: 'Opportunities',
                                    image: AssetImage(
                                      'assets/layers/op_heatmap.png',
                                    ) as ImageProvider,
                                  ),
                                ],
                              ),
                            ),
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
                                return UserSlider(users: bookerLeaders);
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
                                return VenueSlider(venues: dcVenues);
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
                                return VenueSlider(venues: novaVenues);
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
                                return VenueSlider(venues: marylandVenues);
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
                                return UserSlider(users: bookingLeaders);
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
            );
          },
        );
      },
    );
  }
}
