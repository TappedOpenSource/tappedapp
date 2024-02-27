import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/ui/add_past_booking/add_past_booking_cubit.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/geohash.dart';

class ImportSummary extends StatelessWidget {
  const ImportSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AddPastBookingCubit, AddPastBookingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Summary',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              switch (state.flierFile) {
                None() => const SizedBox.shrink(),
                Some(:final value) => Container(
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      image: DecorationImage(
                        image: FileImage(value),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              },
              switch (state.eventName) {
                None() => const SizedBox.shrink(),
                Some(:final value) => Text(
                    value,
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Rubik One',
                    ),
                  ),
              },
              Text(
                state.formattedStartDate,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              switch (state.venue) {
                None() => switch (state.place) {
                    None() => const SizedBox.shrink(),
                    Some(:final value) => Text(
                        formattedFullAddress(value.addressComponents),
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                  },
                Some(:final value) => UserTile(
                    user: state.venue,
                    userId: value.id,
                  ),
              },
              const SizedBox(height: 20),
              switch (state.amountPaid) {
                > 0 => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(width: double.infinity),
                      Text(
                        state.formattedAmount,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Rubik Mono One',
                        ),
                      ),
                      const Text(
                        'Compensation',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                _ => const SizedBox.shrink(),
              },
            ],
          ),
        );
      },
    );
  }
}
