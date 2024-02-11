import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/user_avatar.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:skeletons/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookingContainer extends StatelessWidget {
  const BookingContainer({
    required this.booking,
    this.onConfirm,
    this.onDeny,
    super.key,
  });

  final Booking booking;
  final void Function(Booking)? onConfirm;
  final void Function(Booking)? onDeny;

  Widget venueTile(DatabaseRepository database) =>
      FutureBuilder<Option<UserModel>>(
        future: database.getUserById(booking.requesteeId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return SkeletonListTile();
          }

          final requestee = snapshot.data;

          return switch (requestee) {
            null => SkeletonListTile(),
            None() => SkeletonListTile(),
            Some(:final value) => FutureBuilder<bool>(
                future: database.isVerified(value.id),
                builder: (context, snapshot) {
                  final isVerified = snapshot.data ?? false;

                  return Card(
                    child: ListTile(
                      onTap: () {
                        context.push(BookingPage(booking: booking));
                      },
                      leading: UserAvatar(
                        radius: 20,
                        pushUser: requestee,
                        imageUrl: value.profilePicture.toNullable(),
                        verified: isVerified,
                      ),
                      title: Text(value.displayName),
                      subtitle: Text(
                        timeago.format(
                          booking.startTime,
                          allowFromNow: true,
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        EnumToString.convertToString(booking.status),
                        style: TextStyle(
                          color: () {
                            switch (booking.status) {
                              case BookingStatus.pending:
                                return Colors.orange[300];
                              case BookingStatus.confirmed:
                                return Colors.green[300];
                              case BookingStatus.canceled:
                                return Colors.red[300];
                            }
                          }(),
                        ),
                      ),
                    ),
                  );
                },
              ),
          };
        },
      );

  Widget freeTile(DatabaseRepository database, {
    required String requesterId,
  }) =>
      FutureBuilder<Option<UserModel>>(
        future: database.getUserById(requesterId),
        builder: (context, snapshot) {
          final requester = snapshot.data;

          return switch (requester) {
            null => SkeletonListTile(),
            None() => SkeletonListTile(),
            Some(:final value) => FutureBuilder<bool>(
                future: database.isVerified(value.id),
                builder: (context, snapshot) {
                  final isVerified = snapshot.data ?? false;

                  return Card(
                    child: ListTile(
                      onTap: () {
                        context.push(BookingPage(booking: booking));
                      },
                      leading: UserAvatar(
                        radius: 20,
                        pushUser: requester,
                        imageUrl: value.profilePicture.toNullable(),
                        verified: isVerified,
                      ),
                      title: Text(value.displayName),
                      subtitle: Text(
                        timeago.format(
                          booking.startTime,
                          allowFromNow: true,
                        ),
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      trailing: booking.status == BookingStatus.pending
                          ? GestureDetector(
                              child: const Icon(CupertinoIcons.ellipsis),
                              onTap: () => showCupertinoModalPopup<void>(
                                context: context,
                                builder: (BuildContext context) =>
                                    CupertinoActionSheet(
                                  title: const Text('Booking Request'),
                                  message:
                                      const Text('Accept or Deny the request'),
                                  actions: <CupertinoActionSheetAction>[
                                    CupertinoActionSheetAction(
                                      onPressed: () {
                                        final updated = booking.copyWith(
                                          status: BookingStatus.confirmed,
                                        );
                                        database.updateBooking(updated);
                                        onConfirm?.call(updated);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Accept'),
                                    ),
                                    CupertinoActionSheetAction(
                                      isDestructiveAction: true,
                                      onPressed: () {
                                        final updated = booking.copyWith(
                                          status: BookingStatus.canceled,
                                        );
                                        database.updateBooking(updated);
                                        onDeny?.call(updated);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Deny'),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Text(EnumToString.convertToString(booking.status)),
                    ),
                  );
                },
              ),
          };
        },
      );

  @override
  Widget build(BuildContext context) {
    final databaseRepository =
        RepositoryProvider.of<DatabaseRepository>(context);

    return switch (booking.requesterId) {
      None() => const SizedBox.shrink(),
      Some(:final value) =>
          CurrentUserBuilder(
            errorWidget: const ListTile(
              leading: UserAvatar(
                radius: 25,
              ),
              title: Text('ERROR'),
              subtitle: Text("something isn't working right :/"),
            ),
            builder: (context, currentUser) {
              final isRequester = switch (booking.requesterId) {
                None() => false,
                Some(:final value) => currentUser.id == value,
              };
              return isRequester
                  ? venueTile(databaseRepository)
                  : freeTile(databaseRepository, requesterId: value);
            },
          ),
    };
  }
}
