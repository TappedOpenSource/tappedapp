import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/default_image.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({
    required this.booking,
    required this.visitedUser,
    super.key,
  });

  final Booking booking;
  final UserModel visitedUser;

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final isRequester = switch (booking.requesterId) {
      None() => false,
      Some(:final value) => visitedUser.id == value,
    };
    final formatter = DateFormat.yMEd();
    final formatted = formatter.format(booking.startTime);

    return FutureBuilder(
      future: switch ((booking.requesterId, isRequester)) {
        (None(), _) => database.getUserById(booking.requesteeId),
        (Some(), true) => database.getUserById(booking.requesteeId),
        (Some(:final value), false) => database.getUserById(value),
      },
      builder: (context, snapshot) {
        final user = snapshot.data ?? const None();
        final imageProvider = booking.flierUrl.fold(
          () => user.flatMap((t) => t.profilePicture).fold(
            () => getDefaultImage(Option.of(booking.id)),
            (t) {
              if (t.isNotEmpty) {
                return CachedNetworkImageProvider(t);
              }
              return getDefaultImage(Option.of(booking.id));
            },
          ),
          CachedNetworkImageProvider.new,
        );
        final heroTag = const Uuid().v4();

        final titleText = booking.name.fold(
          () => user.map((t) => t.displayName),
          Option.of,
        );
        return InkWell(
          onTap: () {
            context.push(
              BookingPage(
                booking: booking,
                flierImage: Option.of(
                  HeroImage(
                    imageProvider: imageProvider,
                    heroTag: heroTag,
                  ),
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: heroTag,
                  child: Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                switch (titleText) {
                  None() => const SizedBox.shrink(),
                  Some(:final value) => Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                },
                Text(
                  formatted,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
