import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intheloopapp/ui/discover/discover_cubit.dart';
import 'package:latlong2/latlong.dart';

class CurrentLocationLayer extends StatelessWidget {
  const CurrentLocationLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DiscoverCubit, DiscoverState>(
      builder: (context, state) {
        return MarkerLayer(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(state.userLat, state.userLng),
              child: const Icon(
                Icons.location_on,
                color: Colors.blue,
                size: 25.0,
              ),
            ),
          ],
        );
      },
    );
  }
}
