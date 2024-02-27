import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';
import 'package:intheloopapp/ui/forms/location_form/location_form_view.dart';
import 'package:intheloopapp/ui/forms/location_text_field.dart';

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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AddPastBookingCubit, AddPastBookingState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('search venue'),
            const SizedBox(height: 32),
            _buildDivider(color: theme.colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(height: 32),
            LocationTextField(
              hintText: 'search address',
              initialPlace: state.place,
              onChanged: (place, _) {
                context.read<AddPastBookingCubit>().placeChanged(place);
              },
            ),
          ],
        );
      },
    );
  }
}
