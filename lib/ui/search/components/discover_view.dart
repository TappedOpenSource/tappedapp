import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/profile/components/opportunity_card.dart';
import 'package:intheloopapp/ui/user_card.dart';

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

  Widget _opSlider(List<Opportunity> opportunities) {
    if (opportunities.isEmpty) {
      return const Center(
        child: Text('None rn'),
      );
    }
    return SizedBox(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: opportunities.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            child: OpportunityCard(
              opportunity: opportunities[index],
            ),
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
        database.getRichmondVenues(),
        database.getBookingLeaders(),
        database.getBookerLeaders(),
      ]),
      builder: (context, snapshot) {
        final leaders = snapshot.data ?? [[], [], []];
        final richmondVenues = leaders[0];
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
                  'Featured Opportunities',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder<List<Opportunity>>(
                future: database.getFeaturedOpportunities(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CupertinoActivityIndicator(),
                    );
                  }

                  final opportunities = snapshot.data!;
                  return _opSlider(opportunities);
                },
              ),
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
                  'Top Richmond Venues',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _userSlider(richmondVenues),
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
