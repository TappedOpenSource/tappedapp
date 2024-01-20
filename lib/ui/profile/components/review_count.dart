import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intl/intl.dart';

class ReviewCount extends StatelessWidget {
  const ReviewCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        final performerReviews = state.visitedUser.performerInfo.asNullable()?.reviewCount ?? 0;
        final bookerReviews = state.visitedUser.bookerInfo.asNullable()?.reviewCount ?? 0;
        final allReviewCount = performerReviews + bookerReviews;
        return GestureDetector(
          onTap: () {
            context.push(
              ReviewsPage(
                userId: state.visitedUser.id,
              ),
            );
          },
          child: Column(
            children: [
              Text(
                NumberFormat.compactCurrency(
                  decimalDigits: 0,
                  symbol: '',
                ).format(allReviewCount),
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              if (allReviewCount == 1)
                const Text('Review')
              else
                const Text('Reviews'),
            ],
          ),
        );
      },
    );
  }
}
