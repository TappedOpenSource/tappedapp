import 'package:bloc/bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/user_model.dart';
import 'package:intheloopapp/utils/debouncer.dart';

part 'discover_state.dart';

part 'discover_cubit.freezed.dart';

class DiscoverCubit extends Cubit<DiscoverState> {
  DiscoverCubit({
    required this.search,
  }) : super(const DiscoverState());

  final SearchRepository search;

  final _debouncer = Debouncer(
    const Duration(milliseconds: 150),
    executionInterval: const Duration(milliseconds: 500),
  );

  void onBoundsChange(LatLngBounds? bounds) {
    if (bounds == null) return;

    _debouncer.run(
      () async {
        final hits = await search.queryUsersInBoundingBox(
          '',
          occupations: ['Venue', 'venue'],
          swLatitude: bounds.southWest.latitude,
          swLongitude: bounds.southWest.longitude,
          neLatitude: bounds.northEast.latitude,
          neLongitude: bounds.northEast.longitude,
        );
        emit(state.copyWith(hits: hits));
      },
    );
  }
}
