import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/user_card.dart';
import 'package:intheloopapp/ui/user_tile.dart';

class DiscoverView extends StatelessWidget {
  const DiscoverView({super.key});

  @override
  Widget build(BuildContext context) {
    final database = context.read<DatabaseRepository>();
    return FutureBuilder<List<List<UserModel>>>(
      future: Future.wait([
        database.getViewLeaders(),
        database.getBookingLeaders(),
      ]),
      builder: (context, snapshot) {
        final leaders = snapshot.data ?? [[], []];
        final viewLeaders = leaders[0];
        final bookingLeaders = leaders[1];

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
                  'Top Performers',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (bookingLeaders.isEmpty)
                const Center(
                  child: Text('None rn'),
                )
              else
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: bookingLeaders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: UserCard(user: bookingLeaders[index]),
                      );
                    },
                  ),
                ),
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
              if (viewLeaders.isEmpty)
                const Center(
                  child: Text('None rn'),
                )
              else
                SizedBox(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: viewLeaders.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                        ),
                        child: UserCard(user: viewLeaders[index]),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
