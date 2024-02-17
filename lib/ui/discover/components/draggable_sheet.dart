import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/discover/components/draggable_header.dart';
import 'package:intheloopapp/ui/discover/components/map_config_slider.dart';
import 'package:intheloopapp/ui/discover/components/user_slider.dart';
import 'package:intheloopapp/ui/discover/components/venue_slider.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class DraggableSheet extends StatelessWidget {
  const DraggableSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final theme = Theme.of(context);
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
                    // DraggableHeader(
                    //   scrollController: scrollController,
                    //   bottomSheetDraggableAreaHeight: 32,
                    // ),
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        physics: const ClampingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                    32 / 2 - 4 / 2,
                                  ),
                                  child: Container(
                                    height: 4,
                                    width: 72,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(2)),
                                      color: theme.colorScheme.onSurface.withOpacity(0.3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            MapConfigSlider(),
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
