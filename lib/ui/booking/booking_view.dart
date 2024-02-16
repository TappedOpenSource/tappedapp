import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/service.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;

const defaultProvider = AssetImage(
  'assets/default_avatar.png',
) as ImageProvider;

class BookingView extends StatelessWidget {
  const BookingView({
    required this.booking,
    this.flierImage = const None(),
    this.onConfirm,
    this.onDeny,
    super.key,
  });

  final Booking booking;
  final Option<HeroImage> flierImage;
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
    final validService = booking.serviceId.isSome();
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        final isCurrentUserInvolved = booking.requesterId.fold(
              () => false,
              (t) => t == currentUser.id,
            ) ||
            currentUser.id == booking.requesteeId;

        final ImageProvider<Object> imageProvider = flierImage.fold(
          () => booking.flierUrl.fold(
            () => defaultProvider,
            (flierUrl) {
              if (flierUrl.isNotEmpty) {
                return CachedNetworkImageProvider(flierUrl);
              }
              return defaultProvider;
            },
          ),
          (flier) => flier.imageProvider,
        );

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                stretch: true,
                flexibleSpace: FlexibleSpaceBar(
                  stretchModes: const [
                    StretchMode.zoomBackground,
                    StretchMode.fadeTitle,
                  ],
                  titlePadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  centerTitle: false,
                  title: Text(
                    booking.name.getOrElse(() => ''),
                    style: GoogleFonts.manrope(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  background: GestureDetector(
                    onTap: () => context.push(
                      ImagePage(
                        heroImage: HeroImage(
                          imageProvider: imageProvider,
                          heroTag: flierImage.fold(
                            () => booking.id,
                            (flier) => flier.heroTag,
                          ),
                        ),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Hero(
                          tag: flierImage.fold(
                            () => booking.id,
                            (flier) => flier.heroTag,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.5),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ...<Widget>[
                ...switch (booking.requesterId) {
                  None() => [],
                  Some(:final value) => [
                      const Text(
                        'Booker',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      FutureBuilder<Option<UserModel>>(
                        future: database.getUserById(value),
                        builder: (context, snapshot) {
                          final requester = snapshot.data;
                          return switch (requester) {
                            null => SkeletonListTile(),
                            None() => SkeletonListTile(),
                            Some(:final value) => UserTile(
                                userId: value.id,
                                user: Option.of(value),
                                showFollowButton: false,
                              ),
                          };
                        },
                      ),
                    ],
                },
                const SizedBox(height: 20),
                const Text(
                  'Performer',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder<Option<UserModel>>(
                  future: database.getUserById(booking.requesteeId),
                  builder: (context, snapshot) {
                    final requestee = snapshot.data;
                    return switch (requestee) {
                      null => SkeletonListTile(),
                      None() => SkeletonListTile(),
                      Some(:final value) => UserTile(
                          userId: value.id,
                          user: Option.of(value),
                          showFollowButton: false,
                        ),
                    };
                  },
                ),
                const SizedBox(height: 20),
                if (validService)
                  const Text(
                    'Service',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (validService)
                  FutureBuilder<Option<Service>>(
                    future: validService
                        ? database.getServiceById(
                            booking.requesteeId,
                            booking.serviceId.toNullable()!,
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
                const SizedBox(height: 20),
                if (isCurrentUserInvolved)
                  const Text(
                    'Artist Rate Paid',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (isCurrentUserInvolved)
                  Text(
                    '\$${(booking.rate / 100).toStringAsFixed(2)} / hour',
                  ),
                if (isCurrentUserInvolved) const SizedBox(height: 20),
                const Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FutureBuilder<Option<PlaceData>>(
                  future: context.places.getPlaceById(
                    booking.placeId.getOrElse(() => ''),
                  ),
                  builder: (context, snapshot) {
                    final place = snapshot.data;
                    return Text(
                      place?.match(
                            () => '',
                            (place) => getAddressComponent(
                              place.addressComponents,
                            ),
                          ) ??
                          '',
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Date',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${timeago.format(
                    booking.startTime,
                    allowFromNow: true,
                  )} on $formattedDate',
                ),
                const SizedBox(height: 20),
                const Text(
                  'Duration',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedDuration(
                    booking.endTime.difference(booking.startTime),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Start Time',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedTime(booking.startTime),
                ),
                const SizedBox(height: 20),
                const Text(
                  'End Time',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedTime(booking.endTime),
                ),
                const SizedBox(height: 20),
                if (booking.isPending && booking.requesteeId == currentUser.id)
                  CupertinoButton.filled(
                    onPressed: () {
                      final updated = booking.copyWith(
                        status: BookingStatus.confirmed,
                      );
                      database.updateBooking(updated).then((value) {
                        onConfirm?.call(updated);
                        context.pop();
                      });
                    },
                    child: const Text('Confirm Booking'),
                  ),
                const Text(
                  'to modify the booking, please contact support@tapped.ai',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                if (isCurrentUserInvolved &&
                    !booking.isExpired &&
                    !booking.isCanceled)
                  CupertinoButton(
                    onPressed: () {
                      final updated = booking.copyWith(
                        status: BookingStatus.canceled,
                      );
                      database.updateBooking(updated).then((value) {
                        onDeny?.call(updated);
                        context.pop();
                      });
                    },
                    child: const Text(
                      'Cancel Booking',
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 20),
              ].map(
                (Widget widget) => SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: widget,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
