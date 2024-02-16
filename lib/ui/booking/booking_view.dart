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
        final isCurrentUserInvolved = currentUser.id == booking.requesterId ||
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
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: CustomScrollView(
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
                    background: Hero(
                      tag: flierImage.fold(
                        () => booking.id,
                        (flier) => flier.heroTag,
                      ),
                      child: Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                ...switch (booking.requesterId) {
                  None() => [],
                  Some(:final value) => [
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
                      ),
                    ],
                },
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
                            user: Option.of(value),
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
                  ),
                if (validService)
                  SliverToBoxAdapter(
                    child: FutureBuilder<Option<Service>>(
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
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                if (isCurrentUserInvolved)
                  const SliverToBoxAdapter(
                    child: Text(
                      'Artist Rate Paid',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                if (isCurrentUserInvolved)
                  SliverToBoxAdapter(
                    child: Text(
                      '\$${(booking.rate / 100).toStringAsFixed(2)} / hour',
                    ),
                  ),
                if (isCurrentUserInvolved)
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
                  child: FutureBuilder<Option<PlaceData>>(
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
                if (isCurrentUserInvolved &&
                    !booking.isExpired &&
                    !booking.isCanceled)
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
