import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookingView extends StatelessWidget {
  const BookingView({
    required this.booking,
    this.onConfirm,
    this.onDeny,
    super.key,
  });

  final Booking booking;
  final void Function(Booking)? onConfirm;
  final void Function(Booking)? onDeny;

  String get formattedDate {
    final outputFormat = DateFormat('MM/dd/yyyy');
    final outputDate = outputFormat.format(booking.startTime);
    return outputDate;
  }

  String formattedTime(DateTime time) {
    final outputFormat = DateFormat('HH:mm');
    final outputTime = outputFormat.format(time);
    return outputTime;
  }

  String formattedDuration(Duration d) {
    return d.toString().split('.').first.padLeft(8, '0');
  }

  @override
  Widget build(BuildContext context) {
    final database = RepositoryProvider.of<DatabaseRepository>(context);
    final navigationBloc = context.nav;
    final validService = booking.serviceId.isSome;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          appBar: AppBar(
            title: const Row(
              children: [
                Text(
                  'Booking',
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
            child: CustomScrollView(
              slivers: [
                const SliverToBoxAdapter(
                  child: Text(
                    'Booker',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FutureBuilder<Option<UserModel>>(
                    future: database.getUserById(booking.requesterId),
                    builder: (context, snapshot) {
                      final requester = snapshot.data;
                      return switch (requester) {
                        null => SkeletonListTile(),
                        None() => SkeletonListTile(),
                        Some(:final value) => UserTile(
                            userId: value.id,
                            user: Some(value),
                            showFollowButton: false,
                          ),
                      };
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Performer',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FutureBuilder<Option<UserModel>>(
                    future: database.getUserById(booking.requesteeId),
                    builder: (context, snapshot) {
                      final requestee = snapshot.data;
                      return switch (requestee) {
                        null => SkeletonListTile(),
                        None() => SkeletonListTile(),
                        Some(:final value) => UserTile(
                            userId: value.id,
                            user: Some(value),
                            showFollowButton: false,
                          ),
                      };
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                if (validService)
                  const SliverToBoxAdapter(
                    child: Text(
                      'Service',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  ),
                SliverToBoxAdapter(
                  child: FutureBuilder<Option<Service>>(
                    future: validService
                        ? database.getServiceById(
                            booking.requesteeId,
                            booking.serviceId.unwrap,
                          )
                        : null,
                    builder: (context, snapshot) {
                      final service = snapshot.data;
                      return switch (service) {
                        null => SkeletonListTile(),
                        None() => SkeletonListTile(),
                        Some(:final value) => ListTile(
                            leading: const Icon(Icons.work),
                            title: Text(value.title),
                            subtitle: Text(value.description),
                            trailing: Text(
                              // ignore: lines_longer_than_80_chars
                              '\$${(value.rate / 100).toStringAsFixed(2)}${value.rateType == RateType.hourly ? '/hr' : ''}',
                              style: const TextStyle(
                                color: Colors.green,
                              ),
                            ),
                          ),
                      };
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Artist Rate Paid',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    '\$${(booking.rate / 100).toStringAsFixed(2)} / hour',
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Location',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: FutureBuilder<PlaceData?>(
                    future: context.places.getPlaceById(
                      booking.placeId.unwrapOr(''),
                    ),
                    builder: (context, snapshot) {
                      final place = snapshot.data;
                      return Text(
                        getAddressComponent(
                          place?.addressComponents,
                        ),
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      );
                    },
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Date',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    '${timeago.format(
                      booking.startTime,
                      allowFromNow: true,
                    )} on $formattedDate',
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Duration',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    formattedDuration(
                      booking.endTime.difference(booking.startTime),
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'Start Time',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    formattedTime(booking.startTime),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'End Time',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Text(
                    formattedTime(booking.endTime),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                SliverToBoxAdapter(
                  child:
                      booking.isPending && booking.requesteeId == currentUser.id
                          ? CupertinoButton.filled(
                              onPressed: () async {
                                final updated = booking.copyWith(
                                  status: BookingStatus.confirmed,
                                );
                                await database.updateBooking(updated);
                                onConfirm?.call(updated);
                                navigationBloc.pop();
                              },
                              child: const Text('Confirm Booking'),
                            )
                          : const SizedBox.shrink(),
                ),
                const SliverToBoxAdapter(
                  child: Text(
                    'to modify the booking, please contact support@tapped.ai',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                if (!booking.isExpired && !booking.isCanceled)
                  SliverToBoxAdapter(
                    child: CupertinoButton(
                      onPressed: () async {
                        final updated = booking.copyWith(
                          status: BookingStatus.canceled,
                        );
                        await database.updateBooking(updated);
                        onDeny?.call(updated);
                        navigationBloc.pop();
                      },
                      child: const Text(
                        'Cancel Booking',
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
                else
                  const SliverToBoxAdapter(
                    child: SizedBox.shrink(),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
