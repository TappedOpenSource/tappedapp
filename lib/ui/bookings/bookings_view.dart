import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/bookings/components/bookings_list.dart';
import 'package:intheloopapp/ui/discover/components/venue_card.dart';
import 'package:intheloopapp/ui/profile/components/opportunity_card.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/premium_builder.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  Widget _buildCanceledBookingsSheet(BuildContext context, {
    required List<Booking> canceledBookings,
  }) {
    return SizedBox(
      width: double.infinity,
      child: DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Column(
            children: [
              Expanded(
                child: BookingsList(
                  bookings: canceledBookings,
                  scrollController: scrollController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildUpcomingBookingsSheet(BuildContext context, {
    required List<Booking> upcomingBookings,
  }) {
    return SizedBox(
      width: double.infinity,
      child: DraggableScrollableSheet(
        expand: false,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Column(
            children: [
              Expanded(
                child: BookingsList(
                  bookings: upcomingBookings,
                  scrollController: scrollController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGigsAppliedSheet(BuildContext context, {
    required String currentUserId,
  }) {
    final database = context.database;
    return SizedBox(
      width: double.infinity,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.4,
      child: FutureBuilder(
        future: database.getAppliedOpportunitiesByUserId(
          currentUserId,
        ),
        builder: (context, snapshot) {
          final ops = snapshot.data ?? [];

          return switch (ops.isEmpty) {
            true =>
            const Center(
              child: Text(
                'Nothing Yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            false =>
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ops.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: OpportunityCard(
                          opportunity: e,
                        ),
                      );
                    }).toList(),
                  ),
                ),
          };
        },
      ),
    );
  }

  Widget _buildVenuesContactedSheet(BuildContext context, {
    required String currentUserId,
  }) {
    final database = context.database;
    return SizedBox(
      width: double.infinity,
      height: MediaQuery
          .of(context)
          .size
          .height * 0.35,
      child: FutureBuilder(
        future: database.getContactedVenues(currentUserId),
        builder: (context, snapshot) {
          final venues = snapshot.data ?? [];

          return switch (venues.isEmpty) {
            true =>
            const Center(
              child: Text(
                'Nothing Yet',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            false =>
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: venues.map((e) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                        ),
                        child: VenueCard(
                          venue: e,
                        ),
                      );
                    }).toList(),
                  ),
                ),
          };
        },
      ),
    );
  }

  Widget _buildChip(BuildContext context, {
    required String label,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(24),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        color: theme.colorScheme.onSurface.withOpacity(0.1),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 24,
          ),
          child: Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGif(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Container(
        height: MediaQuery
            .of(context)
            .size
            .height * 0.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 5,
            ),
          ],
          image: const DecorationImage(
            image: AssetImage('assets/edm_loop.gif'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 12,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: Column(
                  children: [
                    const Text(
                      'LOOKING FOR GIGS?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontFamily: 'Rubik One',
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'looking for something to do? check out the latest gigs and events in your area!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CupertinoButton(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      borderRadius: BorderRadius.circular(15),
                      child: const Text(
                        "let's go",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () =>
                          context.push(
                            GigSearchPage(),
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return RefreshIndicator(
          onRefresh: () {
            context.bookings.add(FetchBookings());
            HapticFeedback.mediumImpact();
            return Future<void>(() => null);
          },
          child: Scaffold(
            backgroundColor: Theme
                .of(context)
                .colorScheme
                .background,
            extendBodyBehindAppBar: true,
            body: BlocBuilder<BookingsBloc, BookingsState>(
              builder: (context, state) {
                return SafeArea(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            const SizedBox(width: 20),
                            PremiumBuilder(
                              builder: (context, isPremium) {
                                return switch (isPremium) {
                                  false =>
                                      _buildChip(
                                        context,
                                        label: 'premium',
                                        onPressed: () =>
                                            context.push(
                                              PaywallPage(),
                                            ),
                                      ),
                                  true => const SizedBox.shrink(),
                                };
                              },
                            ),
                            _buildChip(
                              context,
                              label: 'venues contacted',
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return _buildVenuesContactedSheet(
                                      context,
                                      currentUserId: currentUser.id,
                                    );
                                  },
                                );
                              },
                            ),
                            _buildChip(
                              context,
                              label: 'gigs applied',
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return _buildGigsAppliedSheet(
                                      context,
                                      currentUserId: currentUser.id,
                                    );
                                  },
                                );
                              },
                            ),
                            _buildChip(
                              context,
                              label: 'upcoming bookings',
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return _buildUpcomingBookingsSheet(
                                      context,
                                      upcomingBookings: state.upcomingBookings,
                                    );
                                  },
                                );
                              },
                            ),
                            _buildChip(
                              context,
                              label: 'canceled bookings',
                              onPressed: () {
                                showModalBottomSheet<void>(
                                  context: context,
                                  showDragHandle: true,
                                  builder: (context) {
                                    return _buildCanceledBookingsSheet(
                                      context,
                                      canceledBookings: state.canceledBookings,
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      switch (state.pendingBookings.isEmpty) {
                        true => _buildGif(context),
                        false =>
                            Expanded(
                              child: BookingsList(
                                scrollController: ScrollController(),
                                bookings: state.pendingBookings,
                              ),
                            ),
                      },
                      const Spacer(),
                    ],
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
