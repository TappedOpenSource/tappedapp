import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intl/intl.dart';

class FollowerCount extends StatelessWidget {
  const FollowerCount({super.key});

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
              ).format(state.visitedUser.socialMediaAudience),
              style: const TextStyle(
                fontSize: 24,
              ),
            ),
            const Text(
              'Followers',
            ),
          ],
        );
      },
    );
  }
}
