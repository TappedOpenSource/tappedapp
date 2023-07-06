import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/user_card.dart';
import 'package:intheloopapp/ui/user_tile.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  Widget _userSlider(List<UserModel> users) {
    if (users.isEmpty) {
      return const Center(
        child: Text('None rn'),
      );
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: users.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: UserCard(user: users[index]),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();
    return FutureBuilder<List<List<UserModel>>>(
      future: Future.wait([
        database.getViewLeaders(),
        database.getBookingLeaders(),
        database.getBookerLeaders(),
      ]),
      builder: (context, snapshot) {
        final leaders = snapshot.data ?? [[], []];
        final viewLeaders = leaders[0];
        final bookingLeaders = leaders[1];
        final bookerLeaders = leaders[2];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Text(
                  'Top Creators',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _userSlider(viewLeaders),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Text(
                  'Top Bookers',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _userSlider(bookerLeaders),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Text(
                  'Top Performers',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _userSlider(bookingLeaders),
            ],
          ),
        );
      },
    );
  }
}
