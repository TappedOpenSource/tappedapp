import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';

class RequestToPerformConfirmationView extends StatelessWidget {
  const RequestToPerformConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 34,
            horizontal: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text(
                'your request has been sent!',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 28),
              const Text(
                'you will get a DM from the venue if they accept your request and venues usually take 1-2 weeks to respond. you can also check the status of your request in the "bookings" section of your profile.',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      onPressed: () => context.popUntilHome(),
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
                      child: const Text(
                        'okay',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
