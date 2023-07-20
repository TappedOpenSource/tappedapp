import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/payment_user.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    final payments = context.read<PaymentRepository>();

    return switch (stripeConnectedAccountId) {
      None() => const CupertinoButton.filled(
          onPressed: null,
          child: Text(
            'Payments Disabled',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ),
      Some(:final value) => () {
          final stripeAccountId = value;
          return BlocSelector<OnboardingBloc, OnboardingState,
              Option<UserModel>>(
            selector: (state) =>
                state is Onboarded ? Some(state.currentUser) : const None(),
            builder: (context, currentUser) {
              return switch (currentUser) {
                None() => const SizedBox.shrink(),
                Some(:final value) => () {
                    if (value.id == userId) {
                      return const SizedBox.shrink();
                    }

                    return FutureBuilder<Option<PaymentUser>>(
                      future: payments.getAccountById(stripeAccountId),
                      builder: (context, snapshot) {
                        final paymentUser = snapshot.data;

                        return switch (paymentUser) {
                          null => const CupertinoButton.filled(
                              onPressed: null,
                              child: CupertinoActivityIndicator(),
                            ),
                          None() => const CupertinoButton.filled(
                              onPressed: null,
                              child: Text(
                                'Payments Disabled',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          Some(:final value) => () {
                              final enabled = value.payoutsEnabled;

                              if (!enabled) {
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

                              return CupertinoButton.filled(
                                onPressed: () {
                                  final nextPage = switch (service) {
                                    None() => ServiceSelectionPage(
                                        userId: userId,
                                        requesteeStripeConnectedAccountId:
                                            stripeAccountId,
                                      ),
                                    Some(:final value) => CreateBookingPage(
                                        service: value,
                                        requesteeStripeConnectedAccountId:
                                            stripeAccountId,
                                      ),
                                  };
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
            },
          );
        }(),
    };
  }
}
