import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/review.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:skeletons/skeletons.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    required this.review,
    super.key,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    final reviewerId = switch (review) {
      PerformerReview(:final bookerId) => bookerId,
      BookerReview(:final performerId) => performerId,
    };
    final theme = Theme.of(context);
    return FutureBuilder<Option<UserModel>>(
      future: database.getUserById(reviewerId),
      builder: (context, snapshot) {
        return switch (snapshot.data) {
          null => SkeletonListTile(),
          None() => SkeletonListTile(),
          Some(:final value) => value.deleted
              ? const SizedBox.shrink()
              : () {
                  return Card(
                    elevation: 0,
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    child: Column(
                      children: [
                        UserTile(
                          userId: value.id,
                          user: Option.of(value),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 16,
                            right: 16,
                            bottom: 16,
                          ),
                          child: Text(
                            review.overallReview,
                          ),
                        ),
                      ],
                    ),
                  );
                }(),
        };
      },
    );
  }
}
