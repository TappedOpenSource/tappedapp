import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/apply_animation_view.dart';
import 'package:intheloopapp/ui/opportunity_feed/components/opportunity_view.dart';
import 'package:intheloopapp/ui/opportunity_feed/cubit/opportunity_feed_cubit.dart';
import 'package:intheloopapp/ui/themes.dart';

class OpportunityFeed extends StatelessWidget {
  const OpportunityFeed({super.key});

  Widget _buildEmptyFeed(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12
          ),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
              image: const DecorationImage(
                image: AssetImage('assets/classic_edm.gif'),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 12,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                    ),
                    decoration: const BoxDecoration(
                      color: Colors.black,
                    ),
                    child: Column(
                      children: [
                        const Text(
                          "YOU'RE OUT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 32,
                            fontFamily: 'Rubik One',
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                        const Text(
                          "you've gone thru all the opportunities in your area!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),
                        CupertinoButton(
                          color: Theme.of(context).colorScheme.primary,
                          borderRadius: BorderRadius.circular(15),
                          child: const Text(
                            'want more?',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () => context.push(
                            PaywallPage(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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
          return _buildEmptyFeed(context);
        }

        final curOp = state.opportunities[state.curOp];
        return OpportunityView(
          opportunityId: curOp.id,
          opportunity: Option.of(curOp),
          showAppBar: false,
          onDislike: () =>
              context.read<OpportunityFeedCubit>().dislikeOpportunity(),
          onApply: () => context.read<OpportunityFeedCubit>().likeOpportunity(),
          onDismiss: () =>
              context.read<OpportunityFeedCubit>().dismissOpportunity(),
        );
      },
    );
  }
}
