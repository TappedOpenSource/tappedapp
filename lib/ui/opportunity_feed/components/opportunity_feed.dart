import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/ui/loading/loading_container.dart';
import 'package:intheloopapp/ui/loading/loading_view.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_card.dart';
import 'package:intheloopapp/ui/opportunity_feed/cubit/opportunity_feed_cubit.dart';

class OpportunityFeed extends StatelessWidget {
  const OpportunityFeed({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OpportunityFeedCubit, OpportunityFeedState>(
      bloc: context.read<OpportunityFeedCubit>(),
      builder: (context, state) {
        if (state.loading) {
          return const LoadingView();
        }

        if (state.opportunities.isEmpty ||
            state.curOp >= state.opportunities.length) {
          return const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: double.infinity),
              LogoWave(),
              Text(
                "you've gone thru all the opportunities in your area!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        }

        final curOp = state.opportunities[state.curOp];
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: OpportunityCard(
                opportunity: curOp,
              ),
            ),
            Positioned(
              bottom: 42,
              child: Row(
                children: [
                  IconButton.filled(
                    onPressed: () => context
                        .read<OpportunityFeedCubit>()
                        .dislikeOpportunity(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.red,
                      ),
                    ),
                    icon: const Icon(
                      CupertinoIcons.xmark_circle_fill,
                      size: 42,
                    ),
                  ),
                  const SizedBox(width: 69),
                  IconButton.filled(
                    onPressed: () =>
                        context.read<OpportunityFeedCubit>().likeOpportunity(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.green,
                      ),
                    ),
                    icon: const Icon(
                      CupertinoIcons.heart_fill,
                      size: 42,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
