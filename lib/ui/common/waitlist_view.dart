import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/common/easter_egg_placeholder.dart';
import 'package:intheloopapp/ui/loading/logo_wave.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';

class WaitlistView extends StatefulWidget {
  const WaitlistView({super.key});

  @override
  State<WaitlistView> createState() => _WaitlistViewState();
}

class _WaitlistViewState extends State<WaitlistView> {
  bool _loading = false;
  late final ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.database;
    final nav = context.nav;

    if (_loading) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: AppBar(),
          body: FutureBuilder(
            future: database.isOnPremiumWailist(currentUser.id),
            builder: (context, snapshot) {
              final isOnWaitlist = snapshot.data;

              return switch (isOnWaitlist) {
                null => const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                true => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: double.infinity),
                        const LogoWave(),
                        const SizedBox(height: 12),
                        const Text(
                          "you've hit your daily limit!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                        const Text(
                          "we'll let you know when premium is available and you can apply for UNLIMITED opportunities",
                          textAlign: TextAlign.center,
                        ),
                        ConfettiWidget(
                          confettiController: _confettiController,
                          blastDirectionality: BlastDirectionality.explosive,
                          child: FilledButton(
                            onPressed: () {
                              _confettiController.play();
                              context.pop();
                            },
                            child: const Text('okay'),
                          ),
                        ),
                      ],
                    ),
                  ),
                false => Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(width: double.infinity),
                        const EasterEggPlaceholder(
                          text: "you've reached your daily application quota",
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'join the waitlist to get unlimited daily opportunities!',
                        ),
                        const SizedBox(height: 12),
                        Align(
                          child: ConfettiWidget(
                            confettiController: _confettiController,
                            blastDirectionality: BlastDirectionality.explosive,
                            child: FilledButton(
                              onPressed: () async {
                                _confettiController.play();
                                setState(() {
                                  _loading = true;
                                });
                          
                                // apply for the waitlist
                                await database
                                    .joinPremiumWaitlist(currentUser.id);
                                nav.pop();
                                setState(() {
                                  _loading = false;
                                });
                              },
                              child: const Text('sign me up'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              };
            },
          ),
        );
      },
    );
  }
}
