import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/payment_user.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/onboarding_bloc/onboarding_bloc.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class ConnectBankButton extends StatefulWidget {
  const ConnectBankButton({
    super.key,
  });

  @override
  State<ConnectBankButton> createState() => _ConnectBankButtonState();
}

class _ConnectBankButtonState extends State<ConnectBankButton> {
  bool loading = false;

  Widget _connectBankAccountButton({
    required BuildContext context,
    required UserModel currentUser,
    String? accountId,
  }) {
    final payments = context.read<PaymentRepository>();
    final places = context.places;
    final onboarding = context.read<OnboardingBloc>();
    final nav = context.read<NavigationBloc>();
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
    return CupertinoButton.filled(
      onPressed: () async {
        try {
          if (loading) {
            return;
          }

          setState(() {
            loading = true;
          });

          final placeId = currentUser.placeId;
          final place =
              placeId != null ? await places.getPlaceById(placeId) : null;

          final addressComponents = place?.addressComponents ?? [];
          final countryCode = addressComponents
              .where(
                (element) => element.types.contains('country'),
              )
              .firstOrNull
              ?.shortName;

          // create connected account
          final res = await payments.createConnectedAccount(
            accountId: accountId,
            countryCode: countryCode,
          );

          if (!res.success) {
            throw Exception('create connected account failed');
          }

          logger.info('connecting account : accountId ${res.accountId}');
          if (res.accountId != null || res.accountId != '') {
            final updatedUser = currentUser.copyWith(
              stripeConnectedAccountId: res.accountId,
            );

            onboarding.add(
              UpdateOnboardedUser(
                user: updatedUser,
              ),
            );
          }

          nav.pop();

          await launchUrl(
            Uri.parse(res.url),
            mode: LaunchMode.externalApplication,
          );

          setState(() {
            loading = false;
          });
        } catch (e, s) {
          logger.error(
            'error connecting bank account',
            error: e,
            stackTrace: s,
          );
          setState(() {
            loading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: Colors.red,
              content: Text(
                'Error connecting bank account',
              ),
            ),
          );
        }
      },
      borderRadius: BorderRadius.circular(15),
      child: loading
          ? CupertinoActivityIndicator(
              color: onSurfaceColor,
            )
          : Text(
              'Connect Bank Account',
              style: TextStyle(
                color: onSurfaceColor,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final payments = RepositoryProvider.of<PaymentRepository>(context);
    final onSurfaceColor = Theme.of(context).colorScheme.onSurface;

    return CurrentUserBuilder(
      errorWidget: CupertinoButton(
        onPressed: null,
        borderRadius: BorderRadius.circular(15),
        child: const Text(
          'An error has occured :/',
          style: TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      builder: (context, currentUser) {
        if (currentUser.stripeConnectedAccountId == null ||
            currentUser.stripeConnectedAccountId == '') {
          return _connectBankAccountButton(
            context: context,
            currentUser: currentUser,
          );
        }

        return FutureBuilder<Option<PaymentUser>>(
          future: payments.getAccountById(
            currentUser.stripeConnectedAccountId!,
          ),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return CupertinoButton(
                onPressed: null,
                color: onSurfaceColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(15),
                child: const CupertinoActivityIndicator(),
              );
            }

            final paymentUser = snapshot.data;
            return switch (paymentUser) {
              null => CupertinoButton(
                  onPressed: null,
                  color: onSurfaceColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                  child: const CupertinoActivityIndicator(),
                ),
              None() => _connectBankAccountButton(
                  context: context,
                  currentUser: currentUser,
                ),
              Some(:final value) => () {
                  if (!value.payoutsEnabled) {
                    return _connectBankAccountButton(
                      context: context,
                      currentUser: currentUser,
                      accountId: value.id,
                    );
                  }

                  return CupertinoButton(
                    onPressed: null,
                    color: onSurfaceColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                    child: const Text(
                      '✅ Bank Connected',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }(),
            };
          },
        );
      },
    );
  }
}
