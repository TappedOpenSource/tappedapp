import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/payment_user.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class RequestToBookButton extends StatelessWidget {
  const RequestToBookButton({
    required this.userId,
    required this.service,
    required this.stripeConnectedAccountId,
    super.key,
  });

  final String userId;
  final Option<Service> service;
  final Option<String> stripeConnectedAccountId;

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
      onPressed: onPressed,
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
        if (currentUser.id == userId) {
          return const SizedBox.shrink();
        }

        return switch (service) {
          None() => _enabledButton(
              onPressed: () => context.push(
                ServiceSelectionPage(
                  userId: userId,
                  requesteeStripeConnectedAccountId: stripeConnectedAccountId,
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
                          stripeConnectedAccountId,
                    ),
                  ),
                );
              }

              return switch (stripeConnectedAccountId) {
                None() => _disabledButton(),
                Some(:final value) => () {
                    final stripeAccountId = value;
                    return FutureBuilder<Option<PaymentUser>>(
                      future: payments.getAccountById(stripeAccountId),
                      builder: (context, snapshot) {
                        final paymentUser = snapshot.data;

                        return switch (paymentUser) {
                          null => const CupertinoButton.filled(
                              onPressed: null,
                              child: CupertinoActivityIndicator(),
                            ),
                          None() => _disabledButton(),
                          Some(:final value) => () {
                              final enabled = value.payoutsEnabled;

                              if (!enabled) {
                                return _disabledButton();
                              }

                              return CupertinoButton.filled(
                                onPressed: () {
                                  final nextPage = CreateBookingPage(
                                    service: theService,
                                    requesteeStripeConnectedAccountId:
                                        stripeConnectedAccountId,
                                  );
                                  context.push(nextPage);
                                },
                                child: const Text(
                                  'Request to Book',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }(),
                        };
                      },
                    );
                  }(),
              };
            }(),
        };
      },
    );
  }
}
