import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/models/booking.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:intheloopapp/utils/app_logger.dart';
import 'package:latlong2/latlong.dart';

class BookingsPolygonLayer extends StatelessWidget {
  const BookingsPolygonLayer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        if (state.userBookings.isEmpty) {
          return const SizedBox.shrink();
        }

        return PolygonLayer(
          polygons: [
            Polygon(
              points: state.userBookings
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
      },
    );
  }
}
