import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class RequestToBookButton extends StatelessWidget {
  const RequestToBookButton({
    required this.user,
    required this.service,
    super.key,
  });

  final UserModel user;
  final Option<Service> service;

  Widget _disabledButton() {
    return const CupertinoButton.filled(
      onPressed: null,
      child: Text(
        'Payments Disabled',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _enabledButton({
    required void Function() onPressed,
  }) {
    return CupertinoButton.filled(
      onPressed: () {
        HapticFeedback.mediumImpact();
        onPressed();
      },
      child: const Text(
        'Request to Book',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payments = context.payments;

    return CurrentUserBuilder(
      builder: (context, currentUser) {
        if (currentUser.id == user.id) {
          return const SizedBox.shrink();
        }

        return switch (service) {
          None() => _enabledButton(
              onPressed: () => context.push(
                ServiceSelectionPage(
                  userId: user.id,
                  requesteeStripeConnectedAccountId:
                      user.stripeConnectedAccountId,
                ),
              ),
            ),
          Some(:final value) => () {
              final theService = value;
              if (theService.rate >= 0) {
                return _enabledButton(
                  onPressed: () => context.push(
                    CreateBookingPage(
                      service: theService,
                      requesteeStripeConnectedAccountId:
                          user.stripeConnectedAccountId,
                    ),
                  ),
                );
              }

              return FutureBuilder<bool>(
                future: user.hasValidConnectedAccount(payments),
                builder: (context, snapshot) {
                  final isValid = snapshot.data;

                  return switch (isValid) {
                    null => const CupertinoButton.filled(
                        onPressed: null,
                        child: CupertinoActivityIndicator(),
                      ),
                    false => _disabledButton(),
                    true => CupertinoButton.filled(
                        onPressed: () {
                          final nextPage = CreateBookingPage(
                            service: theService,
                            requesteeStripeConnectedAccountId:
                                user.stripeConnectedAccountId,
                          );
                          context.push(nextPage);
                        },
                        child: const Text(
                          'request to book',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                  };
                },
              );
            }(),
        };
      },
    );
  }
}
