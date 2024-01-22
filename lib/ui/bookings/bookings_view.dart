import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/ui/bookings/components/bookings_list.dart';
import 'package:intheloopapp/ui/profile/components/opportunities_list.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

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
    return RefreshIndicator(
      onRefresh: () {
        context.bookings.add(FetchBookings());
        HapticFeedback.mediumImpact();
        return Future<void>(() => null);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBodyBehindAppBar: true,
        // appBar: const TappedAppBar(title: 'Bookings'),
        body: BlocBuilder<BookingsBloc, BookingsState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverToBoxAdapter(
                      child: const Padding(
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
                    ),
                    SliverToBoxAdapter(
                      child: FutureBuilder<List<Opportunity>>(
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
                    ),
                    if (state.pendingBookings.isNotEmpty)
                      const SliverToBoxAdapter(
                        child: Text(
                          'Booking Requests',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (state.pendingBookings.isNotEmpty)
                      BookingsList(
                        bookings: state.pendingBookings,
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),
                    if (state.upcomingBookings.isNotEmpty)
                      const SliverToBoxAdapter(
                        child: Text(
                          'Upcoming Bookings',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (state.upcomingBookings.isNotEmpty)
                      BookingsList(
                        bookings: state.upcomingBookings,
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),
                    if (state.pastBookings.isNotEmpty)
                      const SliverToBoxAdapter(
                        child: Text(
                          'Past Bookings',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (state.pastBookings.isNotEmpty)
                      BookingsList(
                        bookings: state.pastBookings,
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),
                    if (state.canceledBookings.isNotEmpty)
                      const SliverToBoxAdapter(
                        child: Text(
                          'Canceled Bookings',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    if (state.canceledBookings.isNotEmpty)
                      BookingsList(
                        bookings: state.canceledBookings,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
