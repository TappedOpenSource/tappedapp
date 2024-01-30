import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/premium_builder.dart';

class GigSearchInitView extends StatelessWidget {
  const GigSearchInitView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return PremiumBuilder(
      builder: (context, claim) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: Column(
                children: [
                  const Spacer(),
                  const Text(
                    '🚀 Find Gigs: Discover perfect venues for your unique sound.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    "✉️ Hassle-Free Bookings: Submit with a tap; we'll handle the rest.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '📆 Manage Gigs: Keep all your performances organized in one place.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '📣 Automated Outreach: We connect you with venues, so you focus on the music.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'this is experimental',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: CupertinoButton.filled(
                          onPressed: switch (claim) {
                            None() => () => context.push(
                                  PaywallPage(),
                                ),
                            Some(:final value) => () => context.push(
                                  GigSearchPage(),
                                ),
                          },
                          borderRadius: BorderRadius.circular(15),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "let's do it",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 8),
                              Icon(
                                CupertinoIcons.arrow_right,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
