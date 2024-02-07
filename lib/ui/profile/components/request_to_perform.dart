import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';

class RequestToPerform extends StatelessWidget {
  const RequestToPerform({
    required this.venue,
    super.key,
  });

  final UserModel venue;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bookingEmail = venue.venueInfo.flatMap((t) => t.bookingEmail);
    return switch (bookingEmail) {
      None() => const SizedBox.shrink(),
      Some(:final value) => CustomClaimsBuilder(
          builder: (context, claims) {
            final isPremium = claims.contains(CustomClaim.premium);
            return SizedBox(
              width: double.infinity,
              child: CupertinoButton(
                onPressed: () {
                  if (!isPremium) {
                    context.push(PaywallPage());
                    return;
                  }

                  context.push(
                    RequestToPerformPage(
                      bookingEmail: value,
                      venue: venue,
                    ),
                  );
                },
                color: theme.colorScheme.primary,
                child: const Text(
                  'Request to Perform',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
    };
  }
}
