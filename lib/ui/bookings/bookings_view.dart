import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/ui/bookings/components/bookings_list.dart';
import 'package:intheloopapp/ui/discover/components/venue_slider.dart';
import 'package:intheloopapp/ui/profile/components/opportunities_list.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  Widget _opSlider(List<Opportunity> opportunities) {
    if (opportunities.isEmpty) {
      return const Center(
        child: Text('None rn'),
      );
    }
    return OpportunitiesList(opportunities: opportunities);
  }

  List<Widget> _buildContactedVenueSlivers(
    BuildContext context,
    String currentUserId,
  ) {
    final database = context.database;
    return [
      const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Text(
          'Venues Contacted',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      FutureBuilder(
        future: database.getContactedVenues(currentUserId),
        builder: (context, snapshot) {
          final venues = snapshot.data ?? [];

          return switch (venues.isEmpty) {
            true => const Center(
                child: Text('None rn'),
              ),
            false => VenueSlider(venues: venues),
          };
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return RefreshIndicator(
          onRefresh: () {
            context.bookings.add(FetchBookings());
            HapticFeedback.mediumImpact();
            return Future<void>(() => null);
          },
          child: Scaffold(
            backgroundColor: Theme.of(context).colorScheme.background,
            extendBodyBehindAppBar: true,
            body: BlocBuilder<BookingsBloc, BookingsState>(
              builder: (context, state) {
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 20,
                    ),
                    child: CustomScrollView(
                      slivers: [
                        const SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 12,
                            ),
                            child: Text(
                              'Featured Opportunities',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: FutureBuilder<List<Opportunity>>(
                            future: database.getFeaturedOpportunities(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CupertinoActivityIndicator(),
                                );
                              }

                              final opportunities = snapshot.data!;
                              return _opSlider(opportunities);
                            },
                          ),
                        ),
                        ..._buildContactedVenueSlivers(
                          context,
                          currentUser.id,
                        ).map(
                          (e) => SliverToBoxAdapter(
                            child: e,
                          ),
                        ),
                        if (state.pendingBookings.isNotEmpty)
                          const SliverToBoxAdapter(
                            child: Text(
                              'Booking Requests',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (state.pendingBookings.isNotEmpty)
                          BookingsList(
                            bookings: state.pendingBookings,
                          ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 12),
                        ),
                        if (state.upcomingBookings.isNotEmpty)
                          const SliverToBoxAdapter(
                            child: Text(
                              'Upcoming Bookings',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (state.upcomingBookings.isNotEmpty)
                          BookingsList(
                            bookings: state.upcomingBookings,
                          ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 12),
                        ),
                        if (state.pastBookings.isNotEmpty)
                          const SliverToBoxAdapter(
                            child: Text(
                              'Past Bookings',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (state.pastBookings.isNotEmpty)
                          BookingsList(
                            bookings: state.pastBookings,
                          ),
                        const SliverToBoxAdapter(
                          child: SizedBox(height: 12),
                        ),
                        if (state.canceledBookings.isNotEmpty)
                          const SliverToBoxAdapter(
                            child: Text(
                              'Canceled Bookings',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        if (state.canceledBookings.isNotEmpty)
                          BookingsList(
                            bookings: state.canceledBookings,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
