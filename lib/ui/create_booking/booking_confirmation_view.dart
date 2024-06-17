import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

class BookingConfirmationView extends StatelessWidget {
  const BookingConfirmationView({
    required this.booking,
    super.key,
  });

  final Booking booking;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 200,
            ),
            const SizedBox(height: 50),
            const Text(
              'Booking Requested!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 50),
            const Text(
          'Your bookings will be confirmed once the Performer accepts!\n\n'

          ' In the meantime, a DM channel has been created' 
          
          ' for you and the Performer and'

          ' an email containing additional steps has been sent to you.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: CupertinoButton.filled(
                onPressed: () {
                  context
                    ..pop()
                    ..pop()
                    ..pop();
                },
                borderRadius: BorderRadius.circular(15),
                child: const Text(
                  'Okay',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
