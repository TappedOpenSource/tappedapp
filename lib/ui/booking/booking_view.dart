import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:intheloopapp/utils/admin_builder.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/default_image.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/hero_image.dart';
import 'package:intl/intl.dart';
import 'package:skeletons/skeletons.dart';
import 'package:timeago/timeago.dart' as timeago;

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
    final theme = Theme.of(context);
    final database = RepositoryProvider.of<DatabaseRepository>(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        final isCurrentUserInvolved = booking.requesterId.fold(
              () => false,
              (t) => t == currentUser.id,
            ) ||
            currentUser.id == booking.requesteeId;

        final imageProvider = flierImage.fold(
          () => booking.flierUrl.fold(
            () => getDefaultImage(const None()),
            (flierUrl) {
              if (flierUrl.isNotEmpty) {
                return CachedNetworkImageProvider(flierUrl);
              }
              return getDefaultImage(const None());
            },
          ),
          (flier) => flier.imageProvider,
        );

        final timeFormat = DateFormat.jm();
        return AdminBuilder(
          builder: (context, isAdmin) {
            return Scaffold(
              backgroundColor: Theme.of(context).colorScheme.background,
              appBar: AppBar(
                actions: [
                  if (isAdmin)
                    IconButton(
                      icon: const Icon(Icons.more_horiz),
                      onPressed: () => showCupertinoModalPopup(
                        context: context,
                        builder: (context) {
                          return CupertinoActionSheet(
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  final scaffoldMessenger =
                                      ScaffoldMessenger.of(context);
                                  // Copy to clipboard
                                  Clipboard.setData(
                                    ClipboardData(
                                      text: booking.id,
                                    ),
                                  ).then((value) {
                                    Navigator.pop(context);
                                    scaffoldMessenger.showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor:
                                            theme.colorScheme.primary,
                                        content: Text(
                                          'latest app version copied to clipboard',
                                        ),
                                      ),
                                    );
                                  });
                                },
                                child: Text(booking.id),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
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
                      child: Hero(
                        tag: flierImage.fold(
                          () => booking.id,
                          (flier) => flier.heroTag,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Container(
                            height: 300,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: imageProvider,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    switch (booking.name) {
                      None() => const SizedBox.shrink(),
                      Some(:final value) => Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                          ),
                          child: Text(
                            value,
                            style: const TextStyle(
                              fontFamily: 'Rubik One',
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                    },

                    const SizedBox(height: 20),
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

                    // const SizedBox(height: 20),
                    // if (validService)
                    //   const Text(
                    //     'Service',
                    //     style: TextStyle(
                    //       fontSize: 28,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // if (validService)
                    //   FutureBuilder<Option<Service>>(
                    //     future: validService
                    //         ? database.getServiceById(
                    //             booking.requesteeId,
                    //             booking.serviceId.toNullable()!,
                    //           )
                    //         : null,
                    //     builder: (context, snapshot) {
                    //       final service = snapshot.data;
                    //       return switch (service) {
                    //         null => SkeletonListTile(),
                    //         None() => SkeletonListTile(),
                    //         Some(:final value) => ListTile(
                    //             leading: const Icon(Icons.work),
                    //             title: Text(value.title),
                    //             subtitle: Text(value.description),
                    //             trailing: Text(
                    //               // ignore: lines_longer_than_80_chars
                    //               '\$${(value.rate / 100).toStringAsFixed(2)}${value.rateType == RateType.hourly ? '/hr' : ''}',
                    //               style: const TextStyle(
                    //                 color: Colors.green,
                    //               ),
                    //             ),
                    //           ),
                    //       };
                    //     },
                    //   ),
                    CupertinoListSection.insetGrouped(
                      backgroundColor: theme.colorScheme.surface,
                      children: [
                        FutureBuilder<Option<PlaceData>>(
                          future: context.places.getPlaceById(
                            booking.location
                                .map((t) => t.placeId)
                                .getOrElse(() => ''),
                          ),
                          builder: (context, snapshot) {
                            final place = snapshot.data;

                            return switch (place) {
                              null => const SizedBox.shrink(),
                              None() => const SizedBox.shrink(),
                              Some(:final value) => CupertinoListTile(
                                  leading: const Icon(
                                    CupertinoIcons.location,
                                  ),
                                  title: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      formattedFullAddress(
                                        value.addressComponents,
                                      ),
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                            };
                          },
                        ),
                        CupertinoListTile(
                          leading: const Icon(
                            CupertinoIcons.calendar,
                          ),
                          title: Text(
                            formattedDate,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        CupertinoListTile(
                          leading: const Icon(
                            CupertinoIcons.time,
                          ),
                          title: Text(
                            '${timeFormat.format(booking.startTime)}',
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        switch (booking.requesterId) {
                          None() => const SizedBox.shrink(),
                          Some(:final value) =>
                            FutureBuilder<Option<UserModel>>(
                              future: database.getUserById(value),
                              builder: (context, snapshot) {
                                final requester = snapshot.data;
                                return switch (requester) {
                                  null => SkeletonListTile(),
                                  None() => SkeletonListTile(),
                                  Some(:final value) => GestureDetector(
                                      onTap: () => context.push(
                                        ProfilePage(
                                          userId: value.id,
                                          user: Option.of(value),
                                        ),
                                      ),
                                      child: CupertinoListTile(
                                        leading: const Icon(
                                          CupertinoIcons.person,
                                        ),
                                        title: Text(
                                          value.displayName,
                                          style: TextStyle(
                                            color: theme.colorScheme.primary,
                                          ),
                                        ),
                                      ),
                                    ),
                                };
                              },
                            ),
                        },
                        if (isCurrentUserInvolved || isAdmin)
                          CupertinoListTile(
                            leading: const Icon(
                              CupertinoIcons.money_dollar,
                            ),
                            title: Text(
                              '\$${(booking.rate / 100).toStringAsFixed(2)} / hour',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        if (isCurrentUserInvolved || isAdmin)
                          CupertinoListTile(
                            leading: const Icon(
                              CupertinoIcons.info,
                            ),
                            title: Text(
                              'booking ${booking.status.formattedName}',
                              style: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (booking.isPending &&
                        booking.requesteeId == currentUser.id)
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
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'to modify the booking, please contact support@tapped.ai',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
