import 'package:flutter/material.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/utils/geohash.dart';
import 'package:maps_launcher/maps_launcher.dart';

class LocationChip extends StatelessWidget {
  const LocationChip({
    required this.place,
    this.type = PlaceType.LOCALITY,
    this.defaultIdent = 'Unknown',
    super.key,
  });

  final Place place;
  final PlaceType type;
  final String defaultIdent;

  @override
  Widget build(BuildContext context) {
    final fullAddress = formattedFullAddress(place.addressComponents);
    return InkWell(
      onTap: () => MapsLauncher.launchQuery(
        fullAddress,
      ),
      child: Container(
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
              getAddressComponent(
                place.addressComponents,
                type: type,
                defaultIdent: defaultIdent,
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
      ),
    );
  }
}
