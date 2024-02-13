import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/ui/booking_container/booking_container.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class BookingsList extends StatelessWidget {
  const BookingsList({
    required this.bookings,
    required this.scrollController,
    super.key,
  });

  final List<Booking> bookings;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryIconTheme.color ?? Colors.black;

    return bookings.isEmpty
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'Nothing Yet',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: themeColor,
                  ),
                ),
              ),
            ],
          )
        : ListView(
            controller: scrollController,
            children: bookings.map((e) {
              return BookingContainer(
                booking: e,
                onConfirm: (booking) => context.bookings.add(
                  ConfirmBooking(booking: booking),
                ),
                onDeny: (booking) => context.bookings.add(
                  DenyBooking(booking: booking),
                ),
              );
            }).toList(),
          );
  }
}
