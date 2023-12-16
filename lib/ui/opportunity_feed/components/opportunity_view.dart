import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/opportunity_bloc/opportunity_bloc.dart';
import 'package:intheloopapp/ui/themes.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intheloopapp/utils/opportunity_image.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_text/skeleton_text.dart';

class OpportunityView extends StatelessWidget {
  const OpportunityView({
    required this.opportunity,
    this.onApply,
    this.onDislike,
    this.showAppBar = true,
    this.showDislikeButton = true,
    super.key,
  });

  final Opportunity opportunity;
  final bool showDislikeButton;
  final bool showAppBar;
  final void Function()? onApply;
  final void Function()? onDislike;

  Future<Option<Image>> nothing() async {
    return const None();
  }

  Widget buildOpportunityView(
    BuildContext context, {
    required Place place,
  }) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<ImageProvider>(
            future: getOpImage(context, opportunity),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SkeletonAnimation(
                  child: const SizedBox(
                    height: 400,
                    width: double.infinity,
                  ),
                );
              }

              final provider = snapshot.data!;
              return Container(
                height: 400,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: provider,
                    fit: BoxFit.cover,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 600,
                    sigmaY: 1000,
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opportunity.title,
                  style: const TextStyle(
                    fontSize: 32,
                    fontFamily: 'Rubik One',
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'booker',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                UserTile(
                  userId: opportunity.userId,
                  user: const None(),
                ),
                const SizedBox(height: 12),
                const Text(
                  'description',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  opportunity.description,
                ),
                const SizedBox(height: 12),
                const Text(
                  'location',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formattedFullAddress(place.addressComponents),
                ),
                const SizedBox(height: 12),
                const Text(
                  'date',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  DateFormat('MM/dd/yyyy').format(opportunity.startTime),
                ),
                const SizedBox(height: 12),
                const Text(
                  'compensation',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.money_dollar_circle_fill,
                      color: opportunity.isPaid ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      opportunity.isPaid ? 'paid' : 'unpaid',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildApplyButton(
    OpportunityBloc opBloc,
    DatabaseRepository database,
  ) {
    return CurrentUserBuilder(
      builder: (context, currentUser) {
        return FutureBuilder(
          future: database.isUserAppliedForOpportunity(
            opportunity: opportunity,
            userId: currentUser.id,
          ),
          builder: (context, snapshot) {
            final isApplied = snapshot.data;
            return switch (isApplied) {
              null => const CupertinoActivityIndicator(),
              true => const FilledButton(
                  onPressed: null,
                  child: Text('already applied :)'),
                ),
              false => Row(
                  children: [
                    IconButton.filled(
                      onPressed: () {
                        opBloc.add(
                          DislikeOpportunity(
                            opportunity: opportunity,
                          ),
                        );
                        onDislike?.call();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.red,
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.xmark,
                        size: 42,
                      ),
                    ),
                    const SizedBox(width: 69),
                    IconButton.filled(
                      onPressed: () {
                        opBloc.add(
                          ApplyForOpportunity(
                            opportunity: opportunity,
                            userComment: '',
                          ),
                        );
                        onApply?.call();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          tappedAccent,
                        ),
                      ),
                      icon: const Icon(
                        CupertinoIcons.star_fill,
                        size: 42,
                      ),
                    ),
                  ],
                ),
            };
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final places = context.read<PlacesRepository>();
    final opBloc = context.read<OpportunityBloc>();
    final database = context.read<DatabaseRepository>();
    final theme = Theme.of(context);
    return FutureBuilder<Place?>(
      future: places.getPlaceById(
        opportunity.placeId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CupertinoActivityIndicator();
        }

        final place = snapshot.data!;

        return Scaffold(
          backgroundColor: theme.colorScheme.background,
          appBar: showAppBar ? AppBar() : null,
          body: Stack(
            alignment: Alignment.center,
            children: [
              Positioned.fill(
                child: buildOpportunityView(
                  context,
                  place: place,
                ),
              ),
              Positioned(
                bottom: 42,
                child: buildApplyButton(
                  opBloc,
                  database,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
