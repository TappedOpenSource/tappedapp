import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/components/booking_card.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';

class BookingsSliver extends StatelessWidget {
  const BookingsSliver({super.key});

  Widget _addBookingsButton(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        GestureDetector(
          onTap: () => context.push(
            AddPastBookingPage(),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.onSurface.withOpacity(0.1),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: 16),
                      Icon(
                        Icons.add,
                        color: theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Add Past Gigs',
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '(it helps you get more gigs!)',
          style: TextStyle(
            color: theme.colorScheme.onSurface.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _bookingsSlider(
    BuildContext context, {
    required bool isCurrentUser,
    required List<Booking> bookings,
    required UserModel visitedUser,
  }) {
    if (bookings.isEmpty && isCurrentUser) {
      return _addBookingsButton(context);
    }

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: BookingCard(
                  booking: bookings[index],
                  visitedUser: visitedUser,
                ),
              );
            },
          ),
        ),
        if (isCurrentUser) _addBookingsButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final latestBookings = state.latestBookings;
        final isCurrentUser = state.isCurrentUser;
        return switch ((latestBookings.isNotEmpty, isCurrentUser)) {
          (false, false) => const SizedBox.shrink(),
          (_, _) => () {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          context.push(
                            BookingsPage(userId: state.visitedUser.id),
                          );
                        },
                        child: const Row(
                          children: [
                            Text(
                              'Booking History',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              'see all',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: tappedAccent,
                              ),
                            ),
                            Icon(
                              Icons.arrow_outward_rounded,
                              size: 16,
                              color: tappedAccent,
                            ),
                          ],
                        ),
                      ),
                    ),
                    _bookingsSlider(
                      context,
                      isCurrentUser: state.isCurrentUser,
                      bookings: state.latestBookings,
                      visitedUser: state.visitedUser,
                    ),
                  ],
                ),
              );
            }(),
        };
      },
    );
  }
}
