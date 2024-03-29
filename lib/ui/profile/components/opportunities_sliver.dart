import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/profile/components/opportunities_list.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';

class OpportunitiesSliver extends StatelessWidget {
  const OpportunitiesSliver({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state.opportunities.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 16,
              ),
              child: Row(
                children: [
                  Text(
                    'gig opportunities',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            OpportunitiesList(
              opportunities: state.opportunities,
            ),
          ],
        );
      },
    );
  }
}
