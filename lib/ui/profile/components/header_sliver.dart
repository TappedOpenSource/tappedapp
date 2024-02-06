import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/components/feedback_button.dart';
import 'package:intheloopapp/ui/profile/components/follower_count.dart';
import 'package:intheloopapp/ui/profile/components/message_button.dart';
import 'package:intheloopapp/ui/profile/components/request_to_book.dart';
import 'package:intheloopapp/ui/profile/components/review_count.dart';
import 'package:intheloopapp/ui/profile/components/settings_button.dart';
import 'package:intheloopapp/ui/profile/components/star_rating.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/utils/custom_claims_builder.dart';
import 'package:intl/intl.dart';

class HeaderSliver extends StatelessWidget {
  const HeaderSliver({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final capacity = state.visitedUser.venueInfo
              .flatMap((t) => t.capacity)
              .getOrElse(() => 0);
          final isCurrentUser = state.currentUser.id == state.visitedUser.id;
          final bookingEmail =
              state.visitedUser.venueInfo.flatMap((t) => t.bookingEmail);
          return Column(
            children: [
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (capacity > 0)
                    Column(
                      children: [
                        Text(
                          NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol: '',
                          ).format(capacity),
                          style: const TextStyle(
                            fontSize: 24,
                          ),
                        ),
                        const Text(
                          'Capacity',
                        ),
                      ],
                    ),
                  if (state.visitedUser.socialFollowing.audienceSize > 0 ||
                      isCurrentUser)
                    const FollowerCount(),
                  const ReviewCount(),
                  const StarRating(),
                ],
              ),
              const SizedBox(height: 12),
              if (!isCurrentUser && !state.visitedUser.unclaimed)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MessageButton(),
                    ),
                  ],
                ),
              if (state.visitedUser.unclaimed)
                switch (bookingEmail) {
                  None() => const SizedBox.shrink(),
                  Some(:final value) => CustomClaimsBuilder(
                      builder: (context, claims) {
                        final isPremium = claims.contains(CustomClaim.premium);
                        return SizedBox(
                          width: double.infinity,
                          child: CupertinoButton(
                            onPressed: () {
                              if (!isPremium) {
                                context.push(PaywallPage());
                                return;
                              }

                              context.push(
                                RequestToPerformPage(
                                  bookingEmail: value,
                                  venue: state.visitedUser,
                                ),
                              );
                            },
                            color: theme.colorScheme.primary,
                            child: const Text(
                              'Request to Perform',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                },
              if (isCurrentUser)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: SettingsButton(),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: FeedbackButton(),
                    ),
                  ],
                ),
              if (isCurrentUser)
                CustomClaimsBuilder(
                  builder: (context, claims) {
                    final isAdmin = claims.contains(CustomClaim.admin);
                    final isBooker = claims.contains(CustomClaim.booker);
                    return switch (isAdmin || isBooker) {
                      false => const SizedBox.shrink(),
                      true => Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: CupertinoButton(
                              onPressed: () => context.push(AdminPage()),
                              color:
                                  theme.colorScheme.onSurface.withOpacity(0.1),
                              child: Text(
                                'admin dashboard',
                                style: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    };
                  },
                ),
              if (!isCurrentUser && state.services.isNotEmpty)
                const SizedBox(height: 8),
              if (!isCurrentUser && state.services.isNotEmpty)
                SizedBox(
                  width: double.infinity,
                  child: RequestToBookButton(
                    user: state.visitedUser,
                    service: const None(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
