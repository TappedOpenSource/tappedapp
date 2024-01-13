import 'package:flutter/cupertino.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/profile/components/opportunities_list.dart';
import 'package:intheloopapp/ui/user_card.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

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
      child: ScrollSnapList(
        onItemFocus: (index) {},
        selectedItemAnchor: SelectedItemAnchor.START,
        itemCount: users.length,
        itemSize: 200,
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
    return OpportunitiesList(opportunities: opportunities);

    // return SizedBox(
    //   height: 250,
    //   child: ScrollSnapList(
    //     onItemFocus: (int index) {},
    //     // selectedItemAnchor: SelectedItemAnchor.START,
    //     itemSize: cardWidth + 16,
    //     itemBuilder: (context, index) {
    //       final op = opportunities[index];
    //       return Padding(
    //         padding: const EdgeInsets.symmetric(horizontal: 8),
    //         child: OpportunityCard(opportunity: op),
    //       );
    //     },
    //     itemCount: opportunities.length,
    //     // key: sslKey,
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final database = context.database;
    return FutureBuilder<List<List<UserModel>>>(
      future: Future.wait([
        database.getDCVenues(),
        database.getNovaVenues(),
        database.getMarylandVenues(),
        database.getRichmondVenues(),
        database.getBookingLeaders(),
        database.getBookerLeaders(),
      ]),
      builder: (context, snapshot) {
        final leaders = snapshot.data ?? [[], [], [], [], [], []];
        final dcVenues = leaders[0];
        final novaVenues = leaders[1];
        final marylandVenues = leaders[2];
        final richmondVenues = leaders[3];
        final bookingLeaders = leaders[4];
        final bookerLeaders = leaders[5];

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
                  'Featured',
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
                  'Top DC Venues',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _userSlider(dcVenues),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Text(
                  'Top NoVa Venues',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _userSlider(novaVenues),
              const Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 8,
                ),
                child: Text(
                  'Top Maryland Venues',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _userSlider(marylandVenues),
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
