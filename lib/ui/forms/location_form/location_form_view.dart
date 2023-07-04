import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/domains/navigation_bloc/navigation_bloc.dart';
import 'package:intheloopapp/ui/forms/location_form/location_cubit.dart';
import 'package:intheloopapp/ui/forms/location_form/location_results.dart';
import 'package:intheloopapp/ui/forms/location_form/location_search_bar.dart';

class LocationFormView extends StatelessWidget {
  const LocationFormView({
    required this.initialPlace,
    required this.onSelected,
    super.key,
  });

  final Place? initialPlace;
  final void Function(Place?, String) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final places = RepositoryProvider.of<PlacesRepository>(context);
    return BlocProvider(
      create: (context) => LocationCubit(
        places: places,
        onSelected: onSelected,
        navigationBloc: context.read<NavigationBloc>(),
      ),
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          backgroundColor: theme.colorScheme.background,
          title: LocationSearchBar(
            initialPlace: initialPlace,
          ),
        ),
        body: const LocationResults(),
      ),
    );
  }
}