import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';
import 'package:intheloopapp/ui/common/venue_search_bar.dart';
import 'package:intheloopapp/ui/forms/location_text_field.dart';
import 'package:intheloopapp/ui/user_tile.dart';

class EventLocationField extends StatelessWidget {
  const EventLocationField({super.key});

  Widget _buildDivider({required Color color}) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Divider(
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'or',
            style: TextStyle(
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Divider(
              color: color,
            ),
          ),
        ],
      );

  // Widget _buildSearchAnchor() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AddPastBookingCubit, AddPastBookingState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'where was it?',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,

              ),
            ),
            const SizedBox(height: 22),
            switch (state.venue) {
              None() => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    VenueSearchBar(
                      onSelected: (venue) {
                        context.read<AddPastBookingCubit>().venueChanged(
                              Option.of(venue),
                            );
                      },
                    ),
                    const SizedBox(height: 32),
                    _buildDivider(
                        color: theme.colorScheme.onSurface.withOpacity(0.5),),
                    const SizedBox(height: 32),
                    LocationTextField(
                      hintText: 'search address',
                      initialPlace: state.place,
                      onChanged: (place, _) {
                        context.read<AddPastBookingCubit>().placeChanged(place);
                      },
                    ),
                  ],
                ),
              Some(:final value) => UserTile(
                  user: state.venue,
                  userId: value.id,
                  trailing: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: theme.colorScheme.onSurface,
                    ),
                    onPressed: () {
                      context.read<AddPastBookingCubit>().venueChanged(
                            const None(),
                          );
                    },
                  ),
                ),
            },
          ],
        );
      },
    );
  }
}
