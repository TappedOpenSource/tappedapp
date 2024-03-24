import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/payment_repository.dart';
import 'package:intheloopapp/data/stream_repository.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/create_booking/components/create_booking_form.dart';
import 'package:intheloopapp/ui/create_booking/create_booking_cubit.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:skeletons/skeletons.dart';

class CreateBookingView extends StatelessWidget {
  const CreateBookingView({
    required this.requesteeId,
    required this.service,
    required this.requesteeStripeConnectedAccountId,
    super.key,
  });

  final String requesteeId;
  final Option<Service> service;
  final Option<String> requesteeStripeConnectedAccountId;

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final remote = context.remote;

    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return FutureBuilder<double>(
          future: remote.getBookingFee(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const LoadingView();
            }

            final bookingFee = snapshot.data!;

            return BlocProvider(
              create: (context) => CreateBookingCubit(
                currentUser: currentUser,
                requesteeId: requesteeId,
                service: service,
                requesteeStripeConnectedAccountId:
                    requesteeStripeConnectedAccountId,
                bookingFee: bookingFee,
                navigationBloc: context.nav,
                onboardingBloc: context.onboarding,
                database: database,
                streamRepo: RepositoryProvider.of<StreamRepository>(context),
                payments: RepositoryProvider.of<PaymentRepository>(context),
              ),
              child: Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                appBar: AppBar(
                  title: const Row(
                    children: [
                      Text(
                        'Request to Book',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ListView(
                    children: [
                      FutureBuilder<Option<UserModel>>(
                        future: database.getUserById(requesteeId),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SkeletonListTile();
                          }

                          final requestee = snapshot.data;
                          return switch (requestee) {
                            null => SkeletonListTile(),
                            None() => SkeletonListTile(),
                            Some(:final value) => UserTile(
                                userId: value.id,
                                user:Option.of(value),
                              ),
                          };
                        },
                      ),
                      const CreateBookingForm(),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
