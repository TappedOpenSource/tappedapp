import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/ui/bookings/components/bookings_list.dart';
import 'package:intheloopapp/ui/discover/components/venue_card.dart';
import 'package:intheloopapp/ui/profile/components/opportunity_card.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';
import 'package:intheloopapp/utils/premium_builder.dart';

class BookingControlsSliver extends StatelessWidget {
  const BookingControlsSliver({super.key});

  Widget _buildPendingBookingsSheet(
    BuildContext context, {
    required List<Booking> pendingBookings,
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
                  bookings: pendingBookings,
                  scrollController: scrollController,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCanceledBookingsSheet(
    BuildContext context, {
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

  Widget _buildUpcomingBookingsSheet(
    BuildContext context, {
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

  Widget _buildGigsAppliedSheet(
    BuildContext context, {
    required String currentUserId,
  }) {
    final database = context.database;
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.4,
      child: FutureBuilder(
        future: database.getAppliedOpportunitiesByUserId(
          currentUserId,
        ),
        builder: (context, snapshot) {
          final ops = snapshot.data ?? [];

          return switch (ops.isEmpty) {
            true => const Center(
                child: Text(
                  'Nothing Yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            false => SingleChildScrollView(
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

  Widget _buildVenuesContactedSheet(
    BuildContext context, {
    required String currentUserId,
  }) {
    final database = context.database;
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.35,
      child: FutureBuilder(
        future: database.getContactedVenues(currentUserId),
        builder: (context, snapshot) {
          final venues = snapshot.data ?? [];

          return switch (venues.isEmpty) {
            true => const Center(
                child: Text(
                  'Nothing Yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            false => SingleChildScrollView(
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<BookingsBloc, BookingsState>(
      builder: (context, state) {
        return CurrentUserBuilder(
          builder: (context, currentUser) {
            return CustomClaimsBuilder(
              builder: (context, claims) {
                return PremiumBuilder(
                  builder: (context, isPremium) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CupertinoListSection.insetGrouped(
                          backgroundColor: theme.colorScheme.background,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.1),
                                width: 0.5,
                              ),
                            ),
                          ),
                          children: [
                            CupertinoListTile.notched(
                              leading: const Icon(CupertinoIcons.clock_fill),
                              title: Text(
                                'booking requests (${state.pendingBookings.length})',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              trailing:
                                  const Icon(CupertinoIcons.chevron_forward),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) {
                                  return _buildPendingBookingsSheet(
                                    context,
                                    pendingBookings: state.pendingBookings,
                                  );
                                },
                              ),
                            ),
                            CupertinoListTile.notched(
                              leading: const Icon(CupertinoIcons.calendar),
                              title: Text(
                                'upcoming bookings (${state.upcomingBookings.length})',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              trailing:
                                  const Icon(CupertinoIcons.chevron_forward),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) {
                                  return _buildUpcomingBookingsSheet(
                                    context,
                                    upcomingBookings: state.upcomingBookings,
                                  );
                                },
                              ),
                            ),
                            CupertinoListTile.notched(
                              leading: const Icon(CupertinoIcons.xmark),
                              title: Text(
                                'canceled bookings (${state.canceledBookings.length})',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              trailing:
                                  const Icon(CupertinoIcons.chevron_forward),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) {
                                  return _buildCanceledBookingsSheet(
                                    context,
                                    canceledBookings: state.canceledBookings,
                                  );
                                },
                              ),
                            ),
                            CupertinoListTile.notched(
                              leading: const Icon(CupertinoIcons.chat_bubble),
                              title: Text(
                                'contacted venues',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              trailing:
                                  const Icon(CupertinoIcons.chevron_forward),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) {
                                  return _buildVenuesContactedSheet(
                                    context,
                                    currentUserId: currentUser.id,
                                  );
                                },
                              ),
                            ),
                            CupertinoListTile.notched(
                              leading: const Icon(CupertinoIcons.tickets),
                              title: Text(
                                'gigs applied',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              trailing:
                                  const Icon(CupertinoIcons.chevron_forward),
                              onTap: () => showModalBottomSheet(
                                context: context,
                                showDragHandle: true,
                                builder: (context) {
                                  return _buildGigsAppliedSheet(
                                    context,
                                    currentUserId: currentUser.id,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
