import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/ui/discover/discover_view.dart';
import 'package:intheloopapp/ui/premium_theme_cubit.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/premium_builder.dart';

class ShellView extends StatelessWidget {
  const ShellView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return PremiumBuilder(
          builder: (context, isPremium) {
            context
                .read<PremiumThemeCubit>()
                .updateTheme(isPremiumMode: isPremium);
            return BlocBuilder<NavigationBloc, NavigationState>(
              builder: (context, state) {
                return Scaffold(
                  body: isPremium
                      ? const DiscoverView()
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              child: ImageFiltered(
                                imageFilter: ImageFilter.blur(
                                  sigmaX: 8,
                                  sigmaY: 8,
                                ),
                                child: const DiscoverView(),
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                height: double.infinity,
                                width: double.infinity,
                                color: Colors.transparent,
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CupertinoButton.filled(
                                  onPressed: () {
                                    context.push(PaywallPage());
                                  },
                                  borderRadius: BorderRadius.circular(15),
                                  child: const Text(
                                    'unlock 3 day trial',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
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
      },
    );
  }
}
