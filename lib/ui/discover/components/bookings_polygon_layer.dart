import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:latlong2/latlong.dart';

class BookingsPolygonLayer extends StatelessWidget {
  const BookingsPolygonLayer({
    required this.bookings, super.key,
  });

  final List<Booking> bookings;

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const SizedBox.shrink();
    }

    return PolygonLayer(
      polygons: [
        Polygon(
          points: bookings
              .map(
                (booking) => booking.location.map(
                  (location) => LatLng(
                    location.lat,
                    location.lng,
                  ),
                ),
              )
              .whereType<Some<LatLng>>()
              .map((e) => e.value)
              .toList(),
          borderColor: Colors.blue,
          borderStrokeWidth: 2,
          // isFilled: true,
        ),
      ],
    );
  }
}
