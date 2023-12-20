import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/apply_animation_view.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_view.dart';
import 'package:intheloopapp/ui/opportunity_feed/cubit/opportunity_feed_cubit.dart';

class OpportunityFeed extends StatelessWidget {
  const OpportunityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpportunityFeedCubit, OpportunityFeedState>(
      builder: (context, state) {
        if (state.loading) {
          return const Center(
            child: LogoWave(
              height: 100,
              width: 100,
            ),
          );
        }

        if (state.showApplyAnimation) {
          return const ApplyAnimationView();
        }

        if (state.opportunities.isEmpty ||
            state.curOp >= state.opportunities.length) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity),
              LogoWave(
                height: 100,
                width: 100,
              ),
              Text(
                "you've gone thru all the opportunities in your area!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }

        final curOp = state.opportunities[state.curOp];
        return OpportunityView(
          opportunity: curOp,
          showAppBar: false,
          onDislike: () =>
              context.read<OpportunityFeedCubit>().dislikeOpportunity(),
          onApply: () => context.read<OpportunityFeedCubit>().likeOpportunity(),
        );
      },
    );
  }
}
