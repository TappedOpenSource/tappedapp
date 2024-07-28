import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/domains/models/social_following.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class TasksBanner extends StatelessWidget {
  const TasksBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return FutureBuilder(
          future: database.getContactedVenues(currentUser.id),
          builder: (context, snapshot) {
            return BlocBuilder<BookingsBloc, BookingsState>(
              builder: (context, state) {
                final contactedVenuesCount = snapshot.data?.length ?? 1;
                final genres = currentUser.performerInfo
                    .map((p) => p.genres)
                    .getOrElse(() => []);
                final audienceSize = currentUser.socialFollowing.audienceSize;
                final bookings = state.bookings.where(
                  (booking) => booking.status == BookingStatus.confirmed,
                );

                final tasks = [
                  genres.isNotEmpty,
                  audienceSize > 0,
                  bookings.isNotEmpty,
                  contactedVenuesCount > 0,
                ];
                final incompleteTasks = tasks.where((t) => t != true);

                if (incompleteTasks.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade800.withOpacity(0.8),
                          Colors.lightBlue.withOpacity(0.8),
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.checklist,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'you have ${incompleteTasks.length} tasks left to '
                              'complete',
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(TasksPage());
                            },
                            child: const Text(
                              'show tasks',
                              style: TextStyle(
                                color: Colors.white,
                              ),
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
        );
      },
    );
  }
}
