import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/record_label/components/claim_chip.dart';
import 'package:intheloopapp/ui/record_label/components/credits.dart';
import 'package:intheloopapp/ui/record_label/components/grid_item.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/user_claim_builder.dart';

class SubscribedView extends StatelessWidget {
  const SubscribedView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return UserClaimBuilder(
      builder: (context, claim) {
        return CurrentUserBuilder(
          builder: (context, currentUser) {
            return Scaffold(
              backgroundColor: theme.colorScheme.background,
              appBar: AppBar(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'your AI team',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                    ClaimChip(
                      claim: claim,
                    ),
                  ],
                ),
              ),
              body: CustomScrollView(
                slivers: [
                  const SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: Credits(),
                        ),
                      ],
                    ),
                  ),
                  SliverGrid.count(
                    crossAxisCount: 2,
                    children: [
                      GridItem(
                        title: 'Designer',
                        icon: Icons.brush,
                        onTap: () => context.push(GraphicDesignerPage()),
                      ),
                      GridItem(
                        title: 'Social Media Manager',
                        icon: Icons.people,
                        onTap: () => context.push(SocialMediaManagerPage()),
                      ),
                      const GridItem(
                        title: 'Marketer',
                        icon: Icons.mark_email_read,
                        disabled: true,
                      ),
                      const GridItem(
                        title: 'Publicist',
                        icon: Icons.public,
                        disabled: true,
                      ),
                      const GridItem(
                        title: 'A&R',
                        icon: Icons.chat,
                        disabled: true,
                      ),
                      const GridItem(
                        title: 'Lawyer',
                        icon: Icons.gavel,
                        disabled: true,
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
