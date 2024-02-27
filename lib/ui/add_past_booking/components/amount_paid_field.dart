import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';

class AmountPaidField extends StatelessWidget {
  AmountPaidField({super.key});

  final _formatter = CurrencyTextInputFormatter(
    locale: 'en_US',
    decimalDigits: 2,
    symbol: '',
  );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddPastBookingCubit, AddPastBookingState>(
      builder: (context, state) {
        return TextFormField(
            initialValue: _formatter.format(state.amountPaid.toString()),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.attach_money),
              labelText: 'amount paid (optional)',
              prefixText: r'$ ',
            ),
            inputFormatters: <TextInputFormatter>[_formatter],
            onChanged: (input) {
              final value = _formatter.getUnformattedValue().toDouble();
              final usdValue = (value * 100).toInt();
              context.read<AddPastBookingCubit>().amountPaidChanged(usdValue);
            },
        );
      },
    );
  }
}
