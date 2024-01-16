import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/components/badges_chip.dart';
import 'package:intheloopapp/ui/profile/components/feedback_button.dart';
import 'package:intheloopapp/ui/profile/components/follower_count.dart';
import 'package:intheloopapp/ui/profile/components/location_chip.dart';
import 'package:intheloopapp/ui/profile/components/message_button.dart';
import 'package:intheloopapp/ui/profile/components/more_options_button.dart';
import 'package:intheloopapp/ui/profile/components/request_to_book.dart';
import 'package:intheloopapp/ui/profile/components/review_count.dart';
import 'package:intheloopapp/ui/profile/components/settings_button.dart';
import 'package:intheloopapp/ui/profile/components/star_rating.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/utils/admin_builder.dart';

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
          final currPlace = state.place;
          return Column(
            children: [
              const SizedBox(height: 18),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FollowerCount(),
                  ReviewCount(),
                  StarRating(),
                ],
              ),
              const SizedBox(height: 12),
              if (state.visitedUser.id != state.currentUser.id)
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: MessageButton(),
                    ),
                  ],
                )
              else
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
              if (state.visitedUser.id == state.currentUser.id)
                AdminBuilder(
                  builder: (context, isAdmin) {
                    return switch (isAdmin) {
                      false => const Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                          ),
                          child: SizedBox(
                            width: double.infinity,
                            child: FeedbackButton(),
                          ),
                        ),
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
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: RequestToBookButton(
                  userId: state.visitedUser.id,
                  stripeConnectedAccountId: Option.fromNullable(
                    state.visitedUser.stripeConnectedAccountId,
                  ),
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
