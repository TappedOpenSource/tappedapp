import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/components/review_tile.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';

class ReviewsSliver extends StatelessWidget {
  const ReviewsSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return switch (state.latestReview) {
          None() => const SizedBox.shrink(),
          Some(:final value) => () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        context.push(
                          ReviewsPage(
                            userId: state.visitedUser.id,
                          ),
                        );
                      },
                      child: const Row(
                        children: [
                          Text(
                            'Reviews',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            'see all',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w300,
                              color: tappedAccent,
                            ),
                          ),
                          Icon(
                            Icons.arrow_outward_rounded,
                            size: 16,
                            color: tappedAccent,
                          ),
                        ],
                      ),
                    ),
                  ),
                  ReviewTile(
                    review: value,
                  ),
                ],
              );
            }(),
        };
      },
    );
  }
}
