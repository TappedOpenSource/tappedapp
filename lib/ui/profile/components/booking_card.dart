import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intl/intl.dart';

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

        final imageProvider = user.flatMap((t) => t.profilePicture).map((t) {
          if (t.isNotEmpty) {
            return CachedNetworkImageProvider(t);
          }
          return AssetImage('assets/default_avatar.png') as ImageProvider;
        });

        final titleText = user.map((t) => t.displayName);
        return InkWell(
          onTap: () {
            context.push(
              BookingPage(
                booking: booking,
              ),
            );
          },
          borderRadius: BorderRadius.circular(15),
          child: SizedBox(
            width: 150,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: switch (imageProvider) {
                        None() => AssetImage('assets/default_avatar.png')
                            as ImageProvider,
                        Some(:final value) => value,
                      },
                      fit: BoxFit.cover,
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
