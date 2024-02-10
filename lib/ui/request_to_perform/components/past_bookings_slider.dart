import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/profile/components/booking_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class PastBookingsSlider extends StatefulWidget {
  const PastBookingsSlider({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  State<PastBookingsSlider> createState() => _PastBookingsSliderState();
}

class _PastBookingsSliderState extends State<PastBookingsSlider> {
  List<Booking> _latestBookings = [];

  UserModel get _user => widget.user;

  @override
  void initState() {
    super.initState();
    context.database
        .getBookingsByRequestee(
      _user.id,
      status: BookingStatus.confirmed,
      limit: 5,
    )
        .then(
      (bookings) {
        setState(() {
          _latestBookings = bookings;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_latestBookings.isEmpty) {
      return Card(
        color: theme.colorScheme.onSurface.withOpacity(0.1),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'no booking history',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: _latestBookings
          .map((e) => BookingTile(visitedUser: _user, booking: e))
          .toList(),
    );
  }
}
