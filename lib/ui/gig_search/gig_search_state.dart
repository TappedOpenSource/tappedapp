
part of 'gig_search_cubit.dart';

class GigSearchState extends Equatable {
  const GigSearchState({
    this.cities = const [],
    this.genres = const [],
});

  final List<String> cities;
  final List<Genre> genres;

  @override
  List<Object> get props => [
    cities,
    genres,
  ];

  GigSearchState copyWith({
    List<String>? cities,
    List<Genre>? genres,
  }) {
    return GigSearchState(
      cities: cities ?? this.cities,
      genres: genres ?? this.genres,
    );
  }
}

