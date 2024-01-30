import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/bookings/bookings_view.dart';
import 'package:intheloopapp/ui/messaging/messaging_view.dart';
import 'package:intheloopapp/ui/onboarding/onboarding_view.dart';
import 'package:intheloopapp/ui/opportunity_feed/opportunity_feed_view.dart';
import 'package:intheloopapp/ui/premium_theme_cubit.dart';
import 'package:intheloopapp/ui/profile/profile_view.dart';
import 'package:intheloopapp/ui/search/discover_view.dart';
import 'package:intheloopapp/ui/shell/components/bottom_toolbar.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/custom_claim_builder.dart';

class ShellView extends StatelessWidget {
  const ShellView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return OnboardingView();

    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return CustomClaimBuilder(
          builder: (context, claim) {
            final hasClaim = claim.isSome();
            context
                .read<PremiumThemeCubit>()
                .updateTheme(isPremiumMode: hasClaim);
            return BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                return Scaffold(
                  body: IndexedStack(
                    index: state.selectedTab,
                    children: [
                      const OpportunityFeedView(),
                      DiscoverView(),
                      // PaywallView(),
                      const BookingsView(),
                      const MessagingChannelListView(),
                      ProfileView(
                        visitedUserId: currentUser.id,
                        visitedUser: Option.of(currentUser),
                      ),
                    ],
                  ),
                  bottomNavigationBar: BottomToolbar(
                    user: currentUser,
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
