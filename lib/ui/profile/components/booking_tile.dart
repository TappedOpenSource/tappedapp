import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/linkify.dart';
import 'package:skeletons/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookingTile extends StatelessWidget {
  const BookingTile({
    required this.booking,
    required this.visitedUser,
    super.key,
  });

  final Booking booking;
  final UserModel visitedUser;

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return switch (booking.requesterId) {
      None() => FutureBuilder(
          future: database.getUserById(booking.requesteeId),
          builder: (context, snapshot) {
            final requestee = snapshot.data;
            return switch (requestee) {
              null => SkeletonListTile(),
              None() => const SizedBox.shrink(),
              Some(:final value) => ListTile(
                  leading: switch (booking.flierUrl) {
                    None() => const Icon(Icons.book),
                    Some(:final value) => CachedNetworkImage(
                      imageUrl: value,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  },
                  title: RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Performer',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 8)),
                        TextSpan(
                          text: timeago.format(
                            booking.startTime,
                            allowFromNow: true,
                          ),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w200,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Linkify(
                    text:
                        '@${value.username}${booking.name.map((t) => ' - $t').getOrElse(() => '')}',
                  ),
                ),
            };
          },
        ),
      Some(:final value) => FutureBuilder<
            (
              Option<UserModel>,
              Option<UserModel>,
              Option<Service>,
            )>(
          future: () async {
            final [
              requester as Option<UserModel>,
              requestee as Option<UserModel>,
              service as Option<Service>,
            ] = await Future.wait(
              [
                database.getUserById(value),
                database.getUserById(booking.requesteeId),
                () async {
                  return switch (booking.serviceId) {
                    None() => const None(),
                    Some(:final value) => database.getServiceById(
                        booking.requesteeId,
                        value,
                      ),
                  };
                }(),
              ],
            );

            return (requester, requestee, service);
          }(),
          builder: (context, snapshot) {
            final (
              Option<UserModel> requester,
              Option<UserModel> requestee,
              Option<Service> service,
            ) = snapshot.data ??
                (
                  const None(),
                  const None(),
                  const None(),
                );

            final requesterUsername = switch (requester) {
              None() => 'UNKNOWN',
              Some(:final value) => '@${value.username}',
            };

            final requesteeUsername = switch (requestee) {
              None() => 'UNKNOWN',
              Some(:final value) => '@${value.username}',
            };

            final serviceTitle = switch (service) {
              None() => '',
              Some(:final value) => 'for ${value.title}',
            };
            final onSurfaceColor = Theme.of(context).colorScheme.onSurface;
            return ListTile(
              leading: switch (booking.flierUrl) {
                None() => const Icon(Icons.book),
                Some(:final value) => CachedNetworkImage(
                  imageUrl: value,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              },
              title: RichText(
                text: TextSpan(
                  children: [
                    if (visitedUser.id == booking.requesteeId)
                      TextSpan(
                        text: 'Performer',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: onSurfaceColor,
                        ),
                      )
                    else
                      TextSpan(
                        text: 'Booker',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: onSurfaceColor,
                        ),
                      ),
                    const WidgetSpan(child: SizedBox(width: 8)),
                    TextSpan(
                      text: timeago.format(
                        booking.startTime,
                        allowFromNow: true,
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w200,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              subtitle: Linkify(
                text:
                    // ignore: lines_longer_than_80_chars
                    '$requesterUsername booked $requesteeUsername $serviceTitle',
              ),
            );
          },
        ),
    };
  }
}
