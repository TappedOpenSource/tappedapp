import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:intheloopapp/data/database_repository.dart';
import 'package:intheloopapp/data/places_repository.dart';
import 'package:intheloopapp/data/search_repository.dart';
import 'package:intheloopapp/domains/models/genre.dart';
import 'package:intheloopapp/domains/models/option.dart';
import 'package:intheloopapp/domains/models/user_model.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc({
    required this.searchRepository,
    required this.database,
    required this.places,
  }) : super(
          const SearchState(),
        ) {
    on<Search>((event, emit) async {
      await _search(event.query, emit);
    });
    // on<SearchUsersByPrediction>((event, emit) async {
    //   await _searchUsersByPrediction(event.prediction, emit);
    // });
    on<SetAdvancedSearchFilters>((event, emit) async {
      emit(
        state.copyWith(
          occupations: event.occupations,
          genres: event.genres,
          labels: event.labels,
          place: Option.fromNullable(event.place),
          placeId: Option.fromNullable(event.placeId),
        ),
      );
      await _search(state.searchTerm, emit);
    });
    on<ClearFilters>((event, emit) {
      emit(
        state.copyWith(
          occupations: [],
          genres: [],
          labels: [],
          place: const Option.none(),
          placeId: const Option.none(),
        ),
      );
    });
    on<ClearSearch>((event, emit) {
      emit(
        state.copyWith(
          searchTerm: '',
          searchResults: [],
        ),
      );
    });
  }

  Future<void> _search(String query, Emitter<SearchState> emit) async {
    await _searchUsersByUsername(query, emit);
  }

  Future<void> _searchUsersByUsername(
    String input,
    Emitter<SearchState> emit,
  ) async {
    if (input.isNotEmpty ||
        state.occupations.isNotEmpty ||
        state.genres.isNotEmpty ||
        state.labels.isNotEmpty ||
        state.place != null ||
        state.placeId != null) {
      emit(state.copyWith(loading: true, searchTerm: input));
      const duration = Duration(milliseconds: 500);
      final completer = Completer<void>();
      Timer(duration, () async {
        if ((input.isNotEmpty ||
                state.occupations.isNotEmpty ||
                state.genres.isNotEmpty ||
                state.labels.isNotEmpty ||
                state.place != null ||
                state.placeId != null) &&
            input == state.searchTerm) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          // print('Now !!! search term : ${state.searchTerm}');
          final lat = state.place?.lat;
          final lng = state.place?.lng;
          final searchRes = await searchRepository.queryUsers(
            state.searchTerm,
            occupations:
                state.occupations.isNotEmpty ? state.occupations : null,
            genres: state.genres.isNotEmpty
                ? state.genres.map((e) => e.name).toList()
                : null,
            labels: state.labels.isNotEmpty ? state.labels : null,
            lat: lat,
            lng: lng,
          );
          // print('RESULTS: $searchRes');
          emit(
            state.copyWith(
              searchResults: searchRes,
              loading: false,
            ),
          );
        } else {
          //wait.. Because user still writing..        print('Not Now');
          // print('Not Now');
        }
        completer.complete();
      });
      await completer.future;
    } else {
      emit(
        state.copyWith(
          loading: false,
          searchTerm: '',
          searchResults: [],
        ),
      );
    }
  }

  // Future<void> _searchLocations(
  //   String query,
  //   Emitter<SearchState> emit,
  // ) async {
  //   if (query.isNotEmpty) {
  //     emit(
  //       state.copyWith(
  //         loading: true,
  //         searchTerm: query,
  //         searchResultsByLocation: [],
  //       ),
  //     );
  //     const duration = Duration(milliseconds: 500);
  //     final completer = Completer<void>();
  //     Timer(duration, () async {
  //       if (query.isNotEmpty && query == state.searchTerm) {
  //         // input hasn't changed in the last 500 milliseconds..
  //         // you can start search
  //         // print('Now !!! search term : ${state.searchTerm}');

  //         final locationResults = await places.searchPlace(query);
  //         emit(
  //           state.copyWith(
  //             locationResults: locationResults,
  //             loading: false,
  //           ),
  //         );
  //       } else {
  //         //wait.. Because user still writing..        print('Not Now');
  //         // print('Not Now');
  //       }
  //       completer.complete();
  //     });
  //     await completer.future;
  //   } else {
  //     emit(
  //       state.copyWith(
  //         loading: false,
  //         searchTerm: '',
  //         searchResultsByLocation: [],
  //       ),
  //     );
  //   }
  // }

  // Future<void> _searchUsersByPrediction(
  //   AutocompletePrediction prediction,
  //   Emitter<SearchState> emit,
  // ) async {
  //   final placeId = prediction.placeId;
  //   final mainText = prediction.primaryText;
  //   emit(state.copyWith(loading: true, searchTerm: mainText));

  //   final place = await places.getPlaceById(placeId);

  //   // TODO(jonaylor89): In the future, this should be paginated
  //   final searchRes = await database.searchUsersByLocation(
  //     lat: place?.latLng?.lat ?? 0,
  //     lng: place?.latLng?.lng ?? 0,
  //   );
  //   emit(
  //     state.copyWith(
  //       locationResults: [],
  //       searchTerm: mainText,
  //       searchResultsByLocation: searchRes,
  //       loading: false,
  //     ),
  //   );
  // }

  final PlacesRepository places;
  final DatabaseRepository database;
  final SearchRepository searchRepository;
}
