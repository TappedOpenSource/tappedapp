import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/create_booking/create_booking_cubit.dart';

class BookingNameTextField extends StatelessWidget {
  const BookingNameTextField({
    this.controller,
    super.key,
  });

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateBookingCubit, CreateBookingState>(
      builder: (context, state) {
        return TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.event),
            labelText: 'event name (optional)',
            hintText: 'something in the water',
          ),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          onChanged: (input) =>
              context.read<CreateBookingCubit>().updateName(input),
        );
      },
    );
  }
}
