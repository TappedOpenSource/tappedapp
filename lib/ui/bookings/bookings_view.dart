import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/ui/bookings/components/bookings_list.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).primaryIconTheme.color ?? Colors.black;
    return RefreshIndicator(
      onRefresh: () {
        context.read<BookingsBloc>().add(FetchBookings());
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 96,
                          ),
                          child: CupertinoButton.filled(
                            onPressed: () {},
                            borderRadius: BorderRadius.circular(15),
                            child: const Text(
                              'get booked',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),
                    const SliverToBoxAdapter(
                      child: Text(
                        'Upcoming Bookings',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BookingsList(
                      bookings: state.upcomingBookings,
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),
                    const SliverToBoxAdapter(
                      child: Text(
                        'Past Bookings',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    BookingsList(
                      bookings: state.pastBookings,
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 12),
                    ),
                    const SliverToBoxAdapter(
                      child: Text(
                        'Canceled Bookings',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
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
