import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/components/booking_card.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';

class BookingsSliver extends StatelessWidget {
  const BookingsSliver({super.key});

  Widget _bookingsSlider({
    required List<Booking> bookings,
    required UserModel visitedUser,
  }) {
    return SizedBox(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return switch (state.latestBookings.isNotEmpty) {
          false => const SizedBox.shrink(),
          true => () {
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
