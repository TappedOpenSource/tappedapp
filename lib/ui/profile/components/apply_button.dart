import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/auth_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/domains/navigation_bloc/tapped_route.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplyButton extends StatefulWidget {
  const ApplyButton({
    required this.opportunity,
    super.key,
  });

  final Opportunity opportunity;

  @override
  State<ApplyButton> createState() => _ApplyButtonState();
}

class _ApplyButtonState extends State<ApplyButton> {
  Opportunity get _opportunity => widget.opportunity;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthRepository>();
    final database = context.database;
    if (loading) {
      return const Column(
        children: [
          CupertinoActivityIndicator(),
          SizedBox(
            width: double.infinity,
            height: 8,
          ),
        ],
      );
    }

    return CurrentUserBuilder(
      builder: (context, currentUser) {
        if (currentUser.id == _opportunity.userId) {
          // TODO: turn this into a widget like partiful
          return SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 32,
              ),
              child: CupertinoButton(
                onPressed: () => context.push(
                  InterestedUsersPage(
                    opportunity: _opportunity,
                  ),
                ),
                borderRadius: BorderRadius.circular(15),
                child: const Text(
                  "see who's interested",
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          );
        }

        return FutureBuilder(
          future: auth.getCustomClaim(),
          builder: (context, snapshot) {
            final claim = snapshot.data;
            if (claim == null) {
              return SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  onPressed: () => launchUrl(
                    Uri(
                      scheme: 'https',
                      path: 'tapped.ai/',
                    ),
                  ),
                  borderRadius: BorderRadius.circular(15),
                  child: const Text('Subscribe to apply'),
                ),
              );
            }

            return FutureBuilder<bool>(
              future: database.isUserAppliedForOpportunity(
                userId: currentUser.id,
                opportunity: _opportunity,
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CupertinoActivityIndicator();
                }

                final applied = snapshot.data!;
                if (applied) {
                  return SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 32,
                      ),
                      child: CupertinoButton(
                        onPressed: null,
                        borderRadius: BorderRadius.circular(15),
                        child: const Text(
                          'Applied',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  );
                }

                return SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 32,
                    ),
                    child: CupertinoButton.filled(
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        database
                            .applyForOpportunity(
                          opportunity: _opportunity,
                          userComment: '',
                          userId: currentUser.id,
                        )
                            .then((value) {
                          setState(() {
                            loading = false;
                          });
                        });
                      },
                      borderRadius: BorderRadius.circular(15),
                      child: const Text(
                        'Apply',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
