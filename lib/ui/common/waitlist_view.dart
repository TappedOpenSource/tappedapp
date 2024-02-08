import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/common/easter_egg_placeholder.dart';
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

  Widget _buildCheckItem({required String text}) {
    return Row(
      children: [
        SizedBox(
          height: 45,
          width: 45,
          child: Icon(
            Icons.check_circle,
            color: Colors.green.withOpacity(0.5),
          ),
        ),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAlreadySignedUp(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            image: DecorationImage(
              image: AssetImage('assets/splash.gif'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "you're on the waitlist!",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "we'll let you know when premium is available where you'll get",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                _buildCheckItem(
                  text: 'unlimited gig opportunities',
                ),
                const SizedBox(height: 24),
                _buildCheckItem(
                  text: 'exclusive info on venues looking for performers',
                ),
                const SizedBox(height: 24),
                _buildCheckItem(
                  text: 'contact info for thousands of venues',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    onPressed: () {
                      _confettiController.play();
                      context.pop();
                    },
                    color: theme.colorScheme.primary,
                    child: const Text(
                      'okay',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWaitlist(
    BuildContext context, {
    required UserModel currentUser,
  }) {
    final database = context.database;
    final nav = context.nav;
    final theme = Theme.of(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 300,
          width: double.infinity,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(32),
              bottomRight: Radius.circular(32),
            ),
            image: DecorationImage(
              image: AssetImage('assets/splash.gif'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "get tapped premium",
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "join the waitlist and we'll let you know when premium is available",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                _buildCheckItem(
                  text: 'unlimited gig opportunities',
                ),
                const SizedBox(height: 24),
                _buildCheckItem(
                  text: 'exclusive info on venues looking for performers',
                ),
                const SizedBox(height: 24),
                _buildCheckItem(
                  text: 'contact info for thousands of venues',
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            child: Row(
              children: [
                Expanded(
                  child: CupertinoButton(
                    onPressed: () async {
                      _confettiController.play();
                      setState(() {
                        _loading = true;
                      });

                      // apply for the waitlist
                      await database.joinPremiumWaitlist(currentUser.id);
                      nav.popUntilHome();
                      setState(() {
                        _loading = false;
                      });
                    },
                    color: theme.colorScheme.primary,
                    child: const Text(
                      'join waitlist',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CupertinoButton(
              onPressed: () {
                nav.pop();
              },
              child: const Text(
                'not now',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.database;

    if (_loading) {
      return const Center(
        child: CupertinoActivityIndicator(),
      );
    }

    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          body: FutureBuilder(
            future: database.isOnPremiumWailist(currentUser.id),
            builder: (context, snapshot) {
              final isOnWaitlist = snapshot.data;

              return switch (isOnWaitlist) {
                null => const Center(
                    child: CupertinoActivityIndicator(),
                  ),
                false => _buildAlreadySignedUp(context),
                true => _buildWaitlist(context, currentUser: currentUser),
              };
            },
          ),
        );
      },
    );
  }
}
