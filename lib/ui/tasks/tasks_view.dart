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

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  Widget _buildTaskItem(
    BuildContext context, {
    required bool isCompleted,
    required String titleLabel,
    required String descriptionLabel,
    required TappedRoute whereToFix,
  }) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    return ListTile(
      leading: isCompleted
          ? Icon(
              Icons.check_circle,
              color: Colors.green.withOpacity(0.3),
            )
          : const Icon(
              Icons.circle_outlined,
              color: Colors.red,
            ),
      title: Text(
        titleLabel,
        style: isCompleted
            ? TextStyle(
                color: onSurface.withOpacity(0.5),
                decoration: TextDecoration.lineThrough,
              )
            : null,
      ),
      subtitle: Text(
        descriptionLabel,
        style: isCompleted
            ? TextStyle(
                color: onSurface.withOpacity(0.5),
                decoration: TextDecoration.lineThrough,
              )
            : null,
      ),
      trailing: IconButton(
        icon: const Icon(Icons.arrow_forward_ios),
        onPressed: isCompleted ? null : () => context.push(whereToFix),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return FutureBuilder(
          future: database.getContactedVenues(currentUser.id),
          builder: (context, snapshot) {
            return BlocBuilder<BookingsBloc, BookingsState>(
              builder: (context, bookingsState) {
                final contactedVenuesCount = snapshot.data?.length ?? 0;
                final genres = currentUser.performerInfo
                    .map((p) => p.genres)
                    .getOrElse(() => []);
                final audienceSize = currentUser.socialFollowing.audienceSize;
                final bookings = bookingsState.bookings.where(
                  (booking) => booking.status == BookingStatus.confirmed,
                );
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('tasks'),
                  ),
                  body: ListView(
                    children: [
                      _buildTaskItem(
                        context,
                        titleLabel: 'add a profile picture',
                        descriptionLabel: 'add a profile picture to your account',
                        isCompleted: currentUser.profilePicture.fold(
                          () => false,
                          (url) => url.isNotEmpty,
                        ),
                        whereToFix: SettingsPage(),
                      ),
                      _buildTaskItem(
                        context,
                        titleLabel: 'add genres',
                        descriptionLabel: 'add what genres you perform',
                        isCompleted: genres.isNotEmpty,
                        whereToFix: SettingsPage(),
                      ),
                      _buildTaskItem(
                        context,
                        titleLabel: 'add social following',
                        descriptionLabel: 'let promoters know how big your'
                            ' online presence is',
                        isCompleted: audienceSize > 0,
                        whereToFix: SettingsPage(),
                      ),
                      _buildTaskItem(
                        context,
                        titleLabel: 'add booking history',
                        descriptionLabel: 'your past performers are '
                            'probably the most important part of your profile',
                        isCompleted: bookings.isNotEmpty,
                        whereToFix: AddPastBookingPage(),
                      ),
                      _buildTaskItem(
                        context,
                        titleLabel: 'context first venue',
                        descriptionLabel: 'contact venues to get your first '
                            'gig on tapped!',
                        isCompleted: contactedVenuesCount > 0,
                        whereToFix: GigSearchPage(),
                      ),
                    ],
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
