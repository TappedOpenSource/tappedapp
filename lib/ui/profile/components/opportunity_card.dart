import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/models/opportunity.dart';
import 'package:intheloopapp/ui/profile/components/apply_button.dart';
import 'package:intheloopapp/ui/profile/components/location_chip.dart';
import 'package:intheloopapp/utils/current_user_builder.dart';
import 'package:intheloopapp/utils/geohash.dart';

class OpportunityCard extends StatelessWidget {
  const OpportunityCard({
    required this.opportunity,
    super.key,
  });

  final Opportunity opportunity;

  @override
  Widget build(BuildContext context) {
    final places = context.read<PlacesRepository>();
    return Card(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        width: 300,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                opportunity.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                opportunity.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  FilledButton(
                    onPressed: () {
                      showModalBottomSheet<void>(
                        showDragHandle: true,
                        context: context,
                        builder: (context) {
                          return SizedBox(
                            height: 600,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    opportunity.title,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    opportunity.description,
                                    style: const TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'compensation',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (opportunity.isPaid)
                                    const Text(
                                      'paid',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    )
                                  else
                                    const Text(
                                      'unpaid',
                                      style: TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'location',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  FutureBuilder<Place?>(
                                    future: places.getPlaceById(
                                      opportunity.placeId,
                                    ),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return const Text(
                                          'unknown',
                                        );
                                      }

                                      final place = snapshot.data!;
                                      return LocationChip(
                                        place: place,
                                      );
                                    },
                                  ),
                                  const Spacer(),
                                  ApplyButton(
                                    opportunity: opportunity,
                                  ),
                                  const SizedBox(height: 32),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Text(
                      'More Info',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (opportunity.isPaid)
                    const Icon(
                      Icons.attach_money,
                      size: 24,
                      color: Colors.green,
                    )
                  else
                    const Icon(
                      Icons.attach_money,
                      size: 24,
                      color: Colors.red,
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
