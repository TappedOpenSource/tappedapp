import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';

class RequestToBookButton extends StatelessWidget {
  const RequestToBookButton({
    required this.user,
    super.key,
  });

  final UserModel user;

  Widget _enabledButton({
    required void Function() onPressed,
  }) {
    return CupertinoButton.filled(
      onPressed: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
      child: const Text(
        'request to book',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        if (currentUser.id == user.id) {
          return const SizedBox.shrink();
        }

        return CustomClaimsBuilder(
          builder: (context, claims) {
            final isBooker = claims.contains(CustomClaim.booker);
            final isAdmin = claims.contains(CustomClaim.admin);
            if (!isBooker && !isAdmin) {
              return const SizedBox.shrink();
            }

            return _enabledButton(
              onPressed: () => context.push(
                CreateBookingPage(
                  requesteeId: user.id,
                  service: const None(),
                  requesteeStripeConnectedAccountId: user.stripeConnectedAccountId,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
