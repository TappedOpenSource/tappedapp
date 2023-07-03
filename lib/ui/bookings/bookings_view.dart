import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/bookings_bloc/bookings_bloc.dart';
import 'package:intheloopapp/ui/bookings/components/bookings_list.dart';

class BookingsView extends StatelessWidget {
  const BookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () {
        context.read<BookingsBloc>().add(FetchBookings());
        return Future<void>(() => null);
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        extendBodyBehindAppBar: true,
        // appBar: const TappedAppBar(title: 'Bookings'),
        body: BlocBuilder<BookingsBloc, BookingsState>(
          builder: (context, state) {
            return SafeArea(
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
                  BookingsList(
                    bookings: state.pendingBookings,
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
            );
          },
        ),
      ),
    );
  }
}
