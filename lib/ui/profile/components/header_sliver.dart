import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/profile/components/badges_chip.dart';
import 'package:intheloopapp/ui/profile/components/follow_button.dart';
import 'package:intheloopapp/ui/profile/components/follower_count.dart';
import 'package:intheloopapp/ui/profile/components/location_chip.dart';
import 'package:intheloopapp/ui/profile/components/message_button.dart';
import 'package:intheloopapp/ui/profile/components/more_options_button.dart';
import 'package:intheloopapp/ui/profile/components/request_to_book.dart';
import 'package:intheloopapp/ui/profile/components/review_count.dart';
import 'package:intheloopapp/ui/profile/components/star_rating.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';

class HeaderSliver extends StatelessWidget {
  const HeaderSliver({super.key});

  @override
  Widget build(BuildContext context) {
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
                    SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: FollowButton(),
                    ),
                  ],
                )
              else
                const SizedBox(
                  width: double.infinity,
                  child: FollowButton(),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '@${state.visitedUser.username}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF757575),
                    ),
                  ),
                  const BadgesChip(),
                  if (currPlace != null)
                    LocationChip(
                      place: currPlace,
                    ),
                  const MoreOptionsButton(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
