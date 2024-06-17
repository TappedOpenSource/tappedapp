import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/discover/components/user_slider.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class RequestToPerformConfirmationView extends StatelessWidget {
  const RequestToPerformConfirmationView({
    required this.venues,
    super.key,
  });

  final List<UserModel> venues;

  Iterable<String> get performerIds => venues
      .map(
        (venue) => venue.venueInfo.fold(
          () => <String>[],
          (info) => info.topPerformerIds,
        ),
      )
      .flatten;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final database = context.database;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 34),
                      const Text(
                        'your request has been sent!',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        "you will get a DM from the venue if they accept your request and venues usually take 1-2 weeks to respond. if you have any questions or if they're taking too long, please contact the venue directly.",
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 28),
                      FutureBuilder<List<UserModel>>(
                        future: (() async {
                          final performerOptions = await Future.wait(
                            performerIds.map(database.getUserById),
                          );
                
                          final performers = performerOptions
                              .whereType<Some<UserModel>>()
                              .map((e) => e.value)
                              .toList();
                
                          return performers;
                        })(),
                        builder: (context, snapshot) {
                          if (performerIds.isEmpty) {
                            return const SizedBox.shrink();
                          }
                
                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                
                          final performers = snapshot.data ?? [];
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                child: Text(
                                  'local contacts',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              UserSlider(users: performers),
                              const SizedBox(height: 12),
                              RichText(
                                text: TextSpan(
                                  text: 'these are the local performers we recommend you contact on instagram. ',
                                  style: TextStyle(
                                    color: theme.colorScheme.onBackground,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: "you're 85% more likely to get booked for a show ",
                                      style: TextStyle(
                                        color: theme.colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const TextSpan(
                                      text: "if you're on a bill with a local",
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton(
                      onPressed: () => context.popUntilHome(),
                      color: theme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(15),
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
            ],
          ),
        ),
      ),
    );
  }
}
