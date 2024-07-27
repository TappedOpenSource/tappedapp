part of 'discover_cubit.dart';

@freezed
class DiscoverState with _$DiscoverState {
  const factory DiscoverState({
    @Default([]) List<UserModel> venueHits,
    @Default([]) List<Booking> userBookings,
    @Default([]) List<Booking> bookingHits,
    @Default([]) List<Opportunity> opportunityHits,
    @Default(MapOverlay.venues) MapOverlay mapOverlay,
    @Default([]) List<Genre> genreFilters,
    @Default(RangeValues(0, 1000)) RangeValues capacityRange,
    @Default(37.5407246) double userLat,
    @Default(-77.4360481) double userLng,
    @Default(false) bool resultsExpired,
    // @Default(false) bool showCurrentUser,
    LatLngBounds? bounds,
  }) = _DiscoverState;
}

@JsonEnum()
enum MapOverlay {
  venues,
  // userBookings,
  // bookings,
  opportunities,
}

extension DiscoverStateX on DiscoverState {
  List<String> get genreFilterStrings {
    return genreFilters.map((e) => e.name).toList();
  }

  List<WeightedLatLng> get weightedVenueLatLngs {
    return venueHits
        .map(
          (hit) {
            final lat = hit.location.map((t) => t.lat);
            final lng = hit.location.map((t) => t.lng);

            return lat.map2(
              lng,
              (t, c) => WeightedLatLng(
                LatLng(t, c),
                1,
              ),
            );
          },
        )
        .where((element) => element.isSome())
        .map((e) => e.getOrElse(() => throw Exception()))
        .toList();
  }

  List<WeightedLatLng> get weightedBookingLatLngs {
    return bookingHits
        .map(
          (hit) {
            final lat = hit.location.map((t) => t.lat);
            final lng = hit.location.map((t) => t.lng);

            return lat.map2(
              lng,
              (t, c) => WeightedLatLng(
                LatLng(t, c),
                1,
              ),
            );
          },
        )
        .where((element) => element.isSome())
        .map((e) => e.getOrElse(() => throw Exception()))
        .toList();
  }

  List<WeightedLatLng> get weightedOpportunityLatLngs {
    return opportunityHits.map(
      (hit) {
        final lat = hit.location.lat;
        final lng = hit.location.lng;

        return WeightedLatLng(
          LatLng(lat, lng),
          1,
        );
      },
    ).toList();
  }

  List<UserModel> get edmVenues {
    return venueHits
        .where(
          (e) => e.venueInfo
              .map(
                (t) => t.genres.contains(Genre.electronic.name),
              )
              .getOrElse(() => false),
        )
        .toList();
  }

  List<UserModel> genreList(Genre genre) {
    return venueHits
        .where(
          (e) => e.venueInfo
              .map(
                (t) => t.genres.contains(genre.name),
              )
              .getOrElse(() => false),
        )
        .toList()
      ..sort((a, b) {
        final aCap = a.venueInfo.flatMap((e) => e.capacity).getOrElse(() => 0);
        final bCap = b.venueInfo.flatMap((e) => e.capacity).getOrElse(() => 0);
        return aCap.compareTo(bCap);
      });
  }

  Iterable<MapEntry<String, int>> get genreCounts {
    final venueGenres = venueHits
        .map(
          (e) => e.venueInfo
              .map(
                (t) => t.genres,
              )
              .getOrElse(() => [])
              .map(
                (t) => t.toLowerCase(),
              ),
        )
        .expand((element) => element)
        .toList();

    final genreMap = venueGenres.fold<Map<String, int>>(
      {},
      (previousValue, element) {
        if (previousValue.containsKey(element)) {
          previousValue[element] = previousValue[element]! + 1;
        } else {
          previousValue[element] = 1;
        }
        return previousValue;
      },
    );

    final sortedGenreMap = genreMap.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return sortedGenreMap;
  }
  // List<PieChartSectionData> get genrePieData {
  //   final genreMap = {for (final e in Genre.values) e: genreList(e).length};
  //
  //   return genreMap.entries
  //       .map(
  //         (e) => PieChartSectionData(
  //           value: e.value.toDouble(),
  //           color: e.key.color,
  //           title: e.key.formattedName,
  //           radius: 50,
  //         ),
  //       )
  //       .toList();
  // }

  int get capacityRangeStart => capacityRange.start.round();
  int get capacityRangeEnd => capacityRange.end.round();
}
