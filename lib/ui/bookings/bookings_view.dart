import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/bookings/components/bookings_list.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final nav = context.nav;
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
                      )
                    else
                      SliverToBoxAdapter(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 400,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: const DecorationImage(
                                  image: AssetImage(
                                    'assets/splash.gif',
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: CupertinoButton.filled(
                                onPressed: () => nav.add(
                                  const ChangeTab(
                                    selectedTab: 0,
                                  ),
                                ),
                                borderRadius: BorderRadius.circular(15),
                                child: const Text(
                                  "let's get you booked!",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
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
