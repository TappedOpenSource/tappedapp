import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/ui/forms/location_form/location_cubit.dart';
import 'package:intheloopapp/utils/geohash.dart';

class LocationSearchBar extends StatelessWidget {
  const LocationSearchBar({
    required this.initialPlace,
    super.key,
  });

  final PlaceData? initialPlace;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return CupertinoSearchTextField(
          placeholder: initialPlace != null
              ? getAddressComponent(initialPlace?.addressComponents)
              : 'Search for a location',
          style: const TextStyle(
            color: Colors.white,
          ),
          onChanged: (input) {
            context.read<LocationCubit>().searchLocations(input);
          },
        );
      },
    );
  }
}
