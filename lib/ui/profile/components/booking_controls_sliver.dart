import 'package:feedback/feedback.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/venue_info.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/bookings/components/bookings_list.dart';
import 'package:intheloopapp/ui/discover/components/venue_card.dart';
import 'package:intheloopapp/ui/profile/components/category_gauge.dart';
import 'package:intheloopapp/ui/profile/components/more_options_button.dart';
import 'package:intheloopapp/ui/profile/components/opportunity_card.dart';
import 'package:intheloopapp/ui/profile/components/social_media_icons.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

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
                            if (state.pendingBookings.isNotEmpty)
                              CupertinoListTile.notched(
                                title: Text(
                                  'booking requests',
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
                            if (state.upcomingBookings.isNotEmpty)
                              CupertinoListTile.notched(
                                leading: const Icon(CupertinoIcons.calendar),
                                title: Text(
                                  'upcoming bookings',
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
                            if (state.canceledBookings.isNotEmpty)
                              CupertinoListTile.notched(
                                leading: const Icon(CupertinoIcons.xmark),
                                title: Text(
                                  'canceled bookings',
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
