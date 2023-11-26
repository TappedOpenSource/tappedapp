import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/ui/profile/profile_cubit.dart';
import 'package:intheloopapp/utils/geohash.dart';

class LocationChip extends StatelessWidget {
  const LocationChip({
    required this.place,
    super.key,
  });

  final Place place;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 6,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade700.withOpacity(0.2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.location_city,
            color: Colors.grey.shade700,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            formattedAddress(
              place.addressComponents,
            ),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
