import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    required this.title,
    required this.image,
    required this.prediction,
    super.key,
  });

  final String title;
  final ImageProvider image;

  final AutocompletePrediction prediction;

  @override
  Widget build(BuildContext context) {
    final search = context.search;
    return InkWell(
      onTap: () {
        search.add(SearchUsersByPrediction(prediction: prediction));
      },
      child: Container(
        height: 150,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: image,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(
            12,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
