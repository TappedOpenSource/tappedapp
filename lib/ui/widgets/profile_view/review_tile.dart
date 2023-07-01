import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/review.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/widgets/common/user_avatar.dart';
import 'package:skeletons/skeletons.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    required this.review,
    super.key,
  });

  final Review review;

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();
    final reviewerId = switch (review) {
      PerformerReview(:final bookerId) => bookerId,
      BookerReview(:final performerId) => performerId,
    };
    return FutureBuilder<Option<UserModel>>(
      future: database.getUserById(reviewerId),
      builder: (context, snapshot) {
        return switch (snapshot.data) {
          null => SkeletonListTile(),
          None() => SkeletonListTile(),
          Some(:final value) => () {
              return ListTile(
                leading: UserAvatar(
                  imageUrl: value.profilePicture,
                  radius: 20,
                ),
                title: Text(value.displayName),
                subtitle: Text(review.overallReview),
              );
            }(),
        };
      },
    );
  }
}
