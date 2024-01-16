import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/activity.dart';
import 'package:intheloopapp/ui/activity/components/booking_reminder_activity_tile.dart';
import 'package:intheloopapp/ui/activity/components/booking_request_activity_tile.dart';
import 'package:intheloopapp/ui/activity/components/booking_update_activity_tile.dart';
import 'package:intheloopapp/ui/activity/components/follow_activity_tile.dart';
import 'package:intheloopapp/ui/activity/components/search_appearance_activity_tile.dart';

class ActivityTile extends StatelessWidget {
  const ActivityTile({required this.activity, super.key});

  final Activity activity;

  @override
  Widget build(BuildContext context) {
    return switch (activity) {
      Follow() => FollowActivityTile(
          activity: activity as Follow,
        ),
      // Like() => LikeActivityTile(
      //     activity: activity as Like,
      //   ),
      // CommentActivity() => CommentActivityTile(
      //     activity: activity as CommentActivity,
      //   ),
      BookingRequest() => BookingRequestActivityTile(
          activity: activity as BookingRequest,
        ),
      BookingUpdate() => BookingUpdateActivityTile(
          activity: activity as BookingUpdate,
        ),
      // CommentMention() => CommentMentionActivityTile(
      //     activity: activity as CommentMention,
      //   ),
      // CommentLike() => CommentLikeActivityTile(
      //     activity: activity as CommentLike,
      //   ),
      // OpportunityInterest() => OpportunityInterestActivityTile(
      //     activity: activity as OpportunityInterest,
      //   ),
      BookingReminder() => BookingReminderActivityTile(
          activity: activity as BookingReminder,
        ),
      SearchAppearance() => SearchAppearanceActivityTile(
          activity: activity as SearchAppearance,
        ),
    };
  }
}
