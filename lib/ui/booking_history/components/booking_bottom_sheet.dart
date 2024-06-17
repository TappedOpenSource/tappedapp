import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/ui/booking_history/booking_history_cubit.dart';
import 'package:intheloopapp/ui/profile/components/booking_card.dart';
import 'package:intheloopapp/ui/profile/components/booking_tile.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class BookingBottomSheet extends StatelessWidget {
  const BookingBottomSheet({
    required this.user,
    super.key,
  });

  final UserModel user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return BlocBuilder<BookingHistoryCubit, BookingHistoryState>(
          builder: (context, state) {
            return DraggableScrollableSheet(
              expand: false,
              initialChildSize: 0.11,
              minChildSize: 0.11,
              snap: true,
              snapSizes: const [0.11, 0.5, 1],
              builder: (context, scrollController) => DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child: CustomScrollView(
                    controller: scrollController,
                    physics: const ClampingScrollPhysics(),
                    slivers: [
                      SliverToBoxAdapter(
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(12),
                            ),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 32 / 2 - 4 / 2,
                              ),
                              child: Container(
                                height: 4,
                                width: 42,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2),
                                  color: theme.colorScheme.onSurface
                                      .withOpacity(0.15),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (currentUser.id == user.id)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: CupertinoButton(
                                    onPressed: () {},
                                    borderRadius: BorderRadius.circular(15),
                                    color: theme.colorScheme.primary
                                        .withOpacity(0.1),
                                    child: Text(
                                      'add booking',
                                      style: TextStyle(
                                        fontSize: 17,
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      SliverToBoxAdapter(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'bookings',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<BookingHistoryCubit>()
                                        .toggleGridView();
                                  },
                                  icon: Icon(
                                    state.gridView
                                        ? Icons.view_list
                                        : Icons.grid_view,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (state.gridView)
                        SliverGrid.count(
                          // itemExtent: 100,
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 15,
                          children: state.bookings.map((booking) {
                            return BookingCard(
                              visitedUser: user,
                              booking: booking,
                            );
                          }).toList(),
                        )
                      else
                        SliverList.builder(
                          itemCount: state.bookings.length,
                          itemBuilder: (context, index) {
                            return BookingTile(
                              visitedUser: user,
                              booking: state.bookings[index],
                            );
                          },
                        ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 50,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
