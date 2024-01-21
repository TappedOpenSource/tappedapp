import 'package:flutter/cupertino.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/profile/components/opportunities_list.dart';
import 'package:intheloopapp/ui/search/components/venue_card.dart';
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
        itemSize: 150 + (8 * 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: UserCard(user: users[index]),
          );
        },
      ),
    );
  }


  Widget _venueSlider(List<UserModel> users) {
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
        itemSize: 200 + (8 * 2),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: VenueCard(venue: users[index]),
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
          FutureBuilder(
            future: database.getBookerLeaders(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              final bookerLeaders = snapshot.data ?? [];
              return _userSlider(bookerLeaders);
            },
          ),
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
          FutureBuilder(
            future: database.getRichmondVenues(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              final richmondVenues = snapshot.data ?? [];
              return _venueSlider(richmondVenues);
            },
          ),
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
          FutureBuilder(
            future: database.getDCVenues(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              final dcVenues = snapshot.data ?? [];
              return _venueSlider(dcVenues);
            },
          ),
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
          FutureBuilder(
            future: database.getNovaVenues(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              final novaVenues = snapshot.data ?? [];
              return _venueSlider(novaVenues);
            },
          ),
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
          FutureBuilder(
            future: database.getMarylandVenues(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              final marylandVenues = snapshot.data ?? [];
              return _venueSlider(marylandVenues);
            },
          ),
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
          FutureBuilder(
            future: database.getBookingLeaders(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              }

              final bookingLeaders = snapshot.data ?? [];
              return _userSlider(bookingLeaders);
            },
          ),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }
}
