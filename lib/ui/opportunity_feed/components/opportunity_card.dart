import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/ui/user_tile.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    required this.opportunity,
    super.key,
  });

  final Opportunity opportunity;

  // required this.startTime,
  // required this.endTime,
  // required this.isPaid,

  Future<Option<Image>> nothing() async {
    return const None();
  }

  @override
  Widget build(BuildContext context) {
    final places = context.read<PlacesRepository>();
    return FutureBuilder<Place?>(
      future: places.getPlaceById(
        opportunity.placeId,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final place = snapshot.data!;
        final photoReference = place.photoMetadatas?.first;
        final imageWidget = switch (opportunity.flierUrl) {
          None() => FutureBuilder<Option<Image>>(
              future: photoReference != null
                  ? places.getPhotoUrlFromReference(photoReference)
                  : nothing(),
              builder: (context, snapshot) {
                final image = snapshot.data;
                return switch (image) {
                  null => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  None() => const Center(
                      child: CupertinoActivityIndicator(),
                    ),
                  Some(:final value) => Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: value.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 600,
                          sigmaY: 1000,
                        ),
                      ),
                    ),
                };
              },
            ),
          Some(:final value) => Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: CachedNetworkImageProvider(
                    value,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 600,
                  sigmaY: 1000,
                ),
              ),
            ),
        };
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              imageWidget,
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
      },
    );
  }
}
