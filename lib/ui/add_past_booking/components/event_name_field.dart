import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';

class EventNameField extends StatelessWidget {
  const EventNameField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPastBookingCubit, AddPastBookingState>(
      builder: (context, state) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(
              18,
            ),
            child: TextFormField(
              initialValue: state.eventName.getOrElse(() => ''),
              decoration: const InputDecoration.collapsed(
                // prefixIcon: Icon(Icons.person),
                // labelText: 'handle (no capitals)',
                hintText: 'event name (optional)',
              ),
              onChanged: (input) =>
                  context.read<AddPastBookingCubit>().eventNameChanged(input),
            ),
          ),
        );
      },
    );
  }
}
