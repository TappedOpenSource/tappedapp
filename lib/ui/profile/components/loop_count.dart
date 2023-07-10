import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/follow_relationship/follow_relationship_view.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intl/intl.dart';

class LoopCount extends StatelessWidget {
  const LoopCount({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () => context.push(
            LoopsPage(
              userId: state.visitedUser.id,
              database: context.read<DatabaseRepository>(),
            ),
          ),
          child: Column(
            children: [
              Text(
                NumberFormat.compactCurrency(
                  decimalDigits: 0,
                  symbol: '',
                ).format(state.visitedUser.loopsCount),
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
              const Text('Loops'),
            ],
          ),
        );
      },
    );
  }
}
