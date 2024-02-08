import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';

class RequestToPerform extends StatelessWidget {
  const RequestToPerform({
    required this.venue,
    super.key,
  });

  final UserModel venue;

  Widget _buildRequestButton(BuildContext context, {required String email}) {
    final theme = Theme.of(context);
    return CustomClaimsBuilder(
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
                  bookingEmail: email,
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
    );
  }

  Widget _buildAlreadyRequested(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        onPressed: null,
        color: Colors.green.withOpacity(0.1),
        child: Text(
          'request sent',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.database;
    final bookingEmail = venue.venueInfo.flatMap((t) => t.bookingEmail);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return switch (bookingEmail) {
          None() => const SizedBox.shrink(),
          Some(:final value) => FutureBuilder(
              future: database.hasUserSentContactRequest(
                user: currentUser,
                venue: venue,
              ),
              builder: (context, snapshot) {
                final alreadyRequested = snapshot.data;
                return switch (alreadyRequested) {
                  null => SizedBox(
                      width: double.infinity,
                      child: CupertinoButton(
                        onPressed: null,
                        color: theme.colorScheme.onSurface.withOpacity(0.1),
                        child: const CupertinoActivityIndicator(),
                      ),
                    ),
                  false => _buildRequestButton(context, email: value),
                  true => _buildAlreadyRequested(context),
                };
              },
            ),
        };
      },
    );
  }
}
