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
              width: 12,
              height: 12,
              point: LatLng(state.userLat, state.userLng),
              child: Container(
                height: 12,
                width: 12,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
