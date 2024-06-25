import 'dart:ui';

import 'package:feedback/feedback.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/performer_info.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/models/venue_info.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/components/category_gauge.dart';
import 'package:intheloopapp/ui/profile/components/days_of_the_week_chart.dart';
import 'package:intheloopapp/ui/profile/components/more_options_button.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/share_profile/share_profile_view.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/premium_builder.dart';
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoSliver extends StatelessWidget {
  const InfoSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final audience = state.visitedUser.socialFollowing.audienceSize;
        final performerInfo = state.visitedUser.performerInfo;
        final venueInfo = state.visitedUser.venueInfo;
        final bookerInfo = state.visitedUser.bookerInfo;
        final genres = performerInfo.map((t) => t.genres).getOrElse(
              () => venueInfo.map((t) => t.genres).getOrElse(() => []),
            );
        final rating = performerInfo.map((t) => t.rating).getOrElse(
              () => bookerInfo.map((t) => t.rating).getOrElse(
                    () => const None(),
                  ),
            );
        final averagePerformerTicketPrice =
            performerInfo.map((t) => t.formattedPriceRange);
        final averageAttendance = performerInfo
            .map(
              (t) => t.averageAttendance.fold(
                () => (audience / 250).round(),
                (attendance) => attendance,
              ),
            )
            .getOrElse(() => 0);
        final label = performerInfo.map((t) => t.label).getOrElse(() => 'None');
        final bookingAgency = performerInfo.flatMap((t) => t.bookingAgency);
        final currPlace = state.place;
        final idealPerformerProfile =
            state.visitedUser.venueInfo.flatMap((t) => t.idealPerformerProfile);
        final bookingEmail = state.visitedUser.venueInfo
            .flatMap((t) => t.bookingEmail)
            .toNullable();
        final formatted = NumberFormat.compactLong();
        return CurrentUserBuilder(
          builder: (context, currentUser) {
            return CustomClaimsBuilder(
              builder: (context, claims) {
                final isAdmin = claims.contains(CustomClaim.admin);
                final isBooker = claims.contains(CustomClaim.booker);
                return PremiumBuilder(
                  builder: (context, isPremium) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CupertinoListSection.insetGrouped(
                          backgroundColor: theme.colorScheme.surface,
                          decoration: BoxDecoration(
                            color: theme.colorScheme.onSurface.withOpacity(0.1),
                            border: Border(
                              bottom: BorderSide(
                                color: theme.colorScheme.onBackground
                                    .withOpacity(0.1),
                                width: 0.5,
                              ),
                            ),
                          ),
                          children: [
                            CupertinoListTile(
                              leading: const Icon(
                                CupertinoIcons.at,
                              ),
                              title: Text(
                                state.visitedUser.username.toString(),
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                            ),
                            switch (currPlace) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => GestureDetector(
                                  onLongPress: () => MapsLauncher.launchQuery(
                                    value.shortFormattedAddress,
                                  ),
                                  child: CupertinoListTile(
                                    leading: const Icon(
                                      CupertinoIcons.location,
                                    ),
                                    title: Text(
                                      formattedShortAddress(
                                        value.addressComponents,
                                      ).toLowerCase(),
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                            },
                            switch (venueInfo) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => CupertinoListTile(
                                  leading: const Icon(
                                    CupertinoIcons.building_2_fill,
                                  ),
                                  title: Text(
                                    value.type.formattedName.toLowerCase(),
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                            },
                            switch (venueInfo) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => switch (value.capacity) {
                                  None() => const SizedBox.shrink(),
                                  Some(:final value) => CupertinoListTile(
                                      leading: const Icon(
                                        CupertinoIcons.person_2_alt,
                                      ),
                                      title: Text(
                                        '${formatted.format(value)} capacity',
                                        style: TextStyle(
                                          color: theme.colorScheme.onSurface,
                                        ),
                                      ),
                                    ),
                                },
                            },
                            if (genres.isNotEmpty)
                              CupertinoListTile(
                                leading: const Icon(
                                  CupertinoIcons.music_note,
                                ),
                                title: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Text(
                                    genres
                                        .map((e) => e.toLowerCase())
                                        .join(', '),
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            switch (performerInfo) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => CupertinoListTile(
                                  leading: const Icon(
                                    CupertinoIcons.person_2_alt,
                                  ),
                                  title: Text(
                                    '${NumberFormat.compactCurrency(
                                      decimalDigits: 0,
                                      symbol: '',
                                    ).format(audience)} followers',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                            },
                            switch (averagePerformerTicketPrice) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => CupertinoListTile(
                                  onTap: () {
                                    if (!isPremium) {
                                      context.push(PaywallPage());
                                      return;
                                    }
                                  },
                                  leading: const Icon(
                                    CupertinoIcons.money_dollar,
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      children: [
                                        if (isPremium)
                                          TextSpan(
                                            text: value,
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          )
                                        else
                                          WidgetSpan(
                                            child: ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 10,
                                                sigmaY: 10,
                                              ),
                                              child: Text(
                                                r'$???',
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                          ),
                                        TextSpan(
                                          text: ' avg. ticket price',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            },
                            switch ((venueInfo, averageAttendance)) {
                              (Some(), _) => const SizedBox.shrink(),
                              (_, <= 0) => const SizedBox.shrink(),
                              (_, _) => CupertinoListTile(
                                  onTap: () {
                                    if (!isPremium) {
                                      context.push(PaywallPage());
                                      return;
                                    }
                                  },
                                  leading: const Icon(
                                    CupertinoIcons.person_3_fill,
                                  ),
                                  title: RichText(
                                    text: TextSpan(
                                      children: [
                                        if (isPremium)
                                          TextSpan(
                                            text: formatted
                                                .format(averageAttendance),
                                            style: TextStyle(
                                              color:
                                                  theme.colorScheme.onSurface,
                                            ),
                                          )
                                        else
                                          WidgetSpan(
                                            child: ImageFiltered(
                                              imageFilter: ImageFilter.blur(
                                                sigmaX: 10,
                                                sigmaY: 10,
                                              ),
                                              child: Text(
                                                '???',
                                                style: TextStyle(
                                                  color: theme
                                                      .colorScheme.onSurface,
                                                ),
                                              ),
                                            ),
                                          ),
                                        TextSpan(
                                          text: ' avg. attendance',
                                          style: TextStyle(
                                            color: theme.colorScheme.onSurface,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                            },
                            if (bookingEmail != null)
                              GestureDetector(
                                onTap: () async {
                                  if (!isPremium) {
                                    context.push(PaywallPage());
                                    return;
                                  }

                                  await Clipboard.setData(
                                    ClipboardData(text: bookingEmail),
                                  );
                                  await HapticFeedback.mediumImpact();
                                  await EasyLoading.showSuccess(
                                    'copied email',
                                    duration: const Duration(milliseconds: 500),
                                  );
                                },
                                child: CupertinoListTile(
                                  leading: const Icon(
                                    CupertinoIcons.mail,
                                  ),
                                  title: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Text(
                                      isPremium
                                          ? bookingEmail
                                          : '*****@email.com',
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            switch (state.visitedUser.phoneNumber) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => GestureDetector(
                                  onTap: () async {
                                    if (!isPremium) {
                                      context.push(PaywallPage());
                                      return;
                                    }

                                    await Clipboard.setData(
                                      ClipboardData(text: value),
                                    );
                                    await HapticFeedback.mediumImpact();
                                    await EasyLoading.showSuccess(
                                      'copied phone',
                                      duration:
                                          const Duration(milliseconds: 500),
                                    );
                                  },
                                  child: CupertinoListTile(
                                    leading: const Icon(
                                      CupertinoIcons.phone,
                                    ),
                                    title: Text(
                                      isPremium ? value : '***-***-****',
                                      style: TextStyle(
                                        color: theme.colorScheme.onSurface,
                                      ),
                                    ),
                                  ),
                                ),
                            },
                            if (label != 'None')
                              CupertinoListTile(
                                leading: const Icon(
                                  CupertinoIcons.tag,
                                ),
                                title: Text(
                                  label.toLowerCase(),
                                  style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            switch (bookingAgency) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => CupertinoListTile(
                                  leading: const Icon(
                                    CupertinoIcons.person_2_alt,
                                  ),
                                  title: Text(
                                    value,
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                ),
                            },
                            switch (rating) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => CupertinoListTile(
                                  leading: const Icon(
                                    CupertinoIcons.star_circle,
                                  ),
                                  title: RatingBarIndicator(
                                    rating: value,
                                    itemBuilder: (context, index) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    itemSize: 20,
                                  ),
                                ),
                            },
                            switch (performerInfo) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => CupertinoListTile.notched(
                                  leading: const Icon(
                                    CupertinoIcons.doc_person_fill,
                                  ),
                                  title: Text(
                                    'press kit',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    CupertinoIcons.chevron_forward,
                                  ),
                                  onTap: switch (value.pressKitUrl) {
                                    None() => () {
                                        showCupertinoModalBottomSheet(
                                          context: context,
                                          builder: (context) {
                                            return ShareProfileView(
                                              userId: state.visitedUser.id,
                                              user:
                                                  Option.of(state.visitedUser),
                                            );
                                          },
                                        );
                                      },
                                    Some(:final value) => () async {
                                        await launchUrl(Uri.parse(value));
                                      },
                                  },
                                ),
                            },
                            switch (idealPerformerProfile) {
                              None() => const SizedBox.shrink(),
                              Some(:final value) => CupertinoListTile(
                                  title: Text(
                                    'ideal performer profile',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  trailing: const Icon(
                                    CupertinoIcons.chevron_forward,
                                  ),
                                  onTap: () {
                                    FirebaseAnalytics.instance.logEvent(
                                      name: 'ideal_performer_profile',
                                      parameters: {
                                        'venue_id': state.visitedUser.id,
                                        'is_premium': isPremium,
                                      },
                                    );

                                    if (!isPremium) {
                                      context.push(PaywallPage());
                                      return;
                                    }

                                    showModalBottomSheet<void>(
                                      context: context,
                                      builder: (context) {
                                        return SafeArea(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 16,
                                              horizontal: 20,
                                            ),
                                            child: SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'what kind of performers do they normally book?',
                                                    style: TextStyle(
                                                      color: theme.colorScheme
                                                          .onSurface,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Text(
                                                    value,
                                                    style: TextStyle(
                                                      color: theme.colorScheme
                                                          .onSurface,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                            },
                            CupertinoListTile(
                              title: Text(
                                'more options',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                ),
                              ),
                              trailing: const MoreOptionsButton(),
                            ),
                          ],
                        ),
                        switch ((venueInfo, state.visitedUser.unclaimed)) {
                          (Some(:final value), true) => GestureDetector(
                              onTap: () {
                                final scaffoldMessenger =
                                    ScaffoldMessenger.of(context);
                                final storage = context.storage;
                                final database = context.database;

                                HapticFeedback.lightImpact();
                                BetterFeedback.of(context)
                                    .show((UserFeedback feedback) {
                                  try {
                                    logger.debug(
                                      'feedback: ${feedback.text} and ${feedback.extra}',
                                    );

                                    storage
                                        .uploadFeedbackScreenshot(
                                      currentUser.id,
                                      feedback.screenshot,
                                    )
                                        .then((imageUrl) {
                                      database.sendFeedback(
                                        currentUser.id,
                                        feedback,
                                        imageUrl,
                                      );
                                    });

                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.green,
                                        content: Text('feedback sent'),
                                      ),
                                    );
                                  } catch (error, stackTrace) {
                                    logger.error(
                                      'error sending feedback',
                                      error: error,
                                      stackTrace: stackTrace,
                                    );
                                    scaffoldMessenger.showSnackBar(
                                      const SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.red,
                                        content: Text('error sending feedback'),
                                      ),
                                    );
                                  }
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Text(
                                  'something incorrect? contact us',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          (_, _) => const SizedBox.shrink(),
                        },
                        const CategoryGauge(),
                        const DaysOfTheWeekChart(),
                      ],
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
