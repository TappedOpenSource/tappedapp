import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intheloopapp/domains/search_bloc/search_bloc.dart';
import 'package:intheloopapp/ui/forms/location_text_field.dart';
import 'package:intheloopapp/utils/bloc_utils.dart';

class LocationFilter extends StatelessWidget {
  const LocationFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        return LocationTextField(
          initialPlace: state.place,
          onChanged: (place, placeId) {
            context.search.add(
              SetAdvancedSearchFilters(
                place: place,
                placeId: Option.of(placeId),
              ),
            );
          },
        );
      },
    );
  }
}
