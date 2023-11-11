part of 'search_bloc.dart';

class SearchState extends Equatable {
  const SearchState({
    required this.tabIndex,
    this.searchResults = const [],
    this.searchResultsByLocation = const [],
    this.locationResults = const [],
    this.searchTerm = '',
    this.lastRememberedSearchTerm = '',
    this.loading = false,
    this.occupations = const [],
    this.genres = const [],
    this.labels = const [],
    this.place,
    this.placeId,
  });

  final List<UserModel> searchResults;
  final List<UserModel> searchResultsByLocation;
  final List<AutocompletePrediction> locationResults;
  final String searchTerm;
  final String lastRememberedSearchTerm;

  final List<String> occupations;
  final List<Genre> genres;
  final List<String> labels;

  final Place? place;
  final String? placeId;

  final int tabIndex;
  final bool loading;

  bool get isNotSearching => searchTerm.isEmpty &&
      occupations.isEmpty &&
      genres.isEmpty &&
      labels.isEmpty &&
      place == null &&
      placeId == null;

  @override
  List<Object?> get props => [
        tabIndex,
        searchResults,
        searchResultsByLocation,
        locationResults,
        searchTerm,
        lastRememberedSearchTerm,
        loading,
        occupations,
        genres,
        labels,
        place,
        placeId,
      ];

  SearchState copyWith({
    List<UserModel>? searchResults,
    List<UserModel>? searchResultsByLocation,
    List<AutocompletePrediction>? locationResults,
    String? searchTerm,
    String? lastRememberedSearchTerm,
    List<String>? occupations,
    List<Genre>? genres,
    List<String>? labels,
    Option<Place>? place,
    Option<String>? placeId,
    int? tabIndex,
    bool? loading,
  }) {
    return SearchState(
      tabIndex: tabIndex ?? this.tabIndex,
      locationResults: locationResults ?? this.locationResults,
      searchResults: searchResults ?? this.searchResults,
      searchResultsByLocation:
          searchResultsByLocation ?? this.searchResultsByLocation,
      searchTerm: searchTerm ?? this.searchTerm,
      lastRememberedSearchTerm:
          lastRememberedSearchTerm ?? this.lastRememberedSearchTerm,
      occupations: occupations ?? this.occupations,
      genres: genres ?? this.genres,
      labels: labels ?? this.labels,
      place: place != null ? place.asNullable() : this.place,
      placeId: placeId != null ? placeId.asNullable() : this.placeId,
      loading: loading ?? this.loading,
    );
  }
}
