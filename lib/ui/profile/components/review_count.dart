import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intl/intl.dart';

class ReviewCount extends StatelessWidget {
  const ReviewCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return Column(
          children: [
            Text(
              NumberFormat.compactCurrency(
                decimalDigits: 0,
                symbol: '',
              ).format(state.visitedUser.reviewCount),
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            if (state.visitedUser.reviewCount == 1)
              const Text('Review')
            else
              const Text('Reviews'),
          ],
        );
      },
    );
  }
}
