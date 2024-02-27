import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';

class AmountPaidField extends StatelessWidget {
  const AmountPaidField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPastBookingCubit, AddPastBookingState>(
      builder: (context, state) {
        return TextFormField(
          initialValue: state.amountPaid.toString(),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.attach_money),
            labelText: 'amount paid (optional)',
          ),
          onChanged: (input) =>
              context.read<AddPastBookingCubit>().amountPaidChanged(input),
        );
      },
    );
  }
}
