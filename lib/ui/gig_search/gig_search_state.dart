part of 'gig_search_cubit.dart';

const maxCapacity = 1000.0;

@freezed
class GigSearchState with _$GigSearchState {
  const factory GigSearchState({
    @Default(None()) Option<PlaceData> place,
    @Default([]) List<Genre> genres,
    @Default([]) List<String> startDate,
    @Default([]) List<String> endDate,
    @Default(RangeValues(0, 200)) RangeValues capacityRange,
    @Default(DateRangeType.fixed) DateRangeType dateRangeType,
    @Default([]) List<SelectableResult> results,
    @Default([]) List<UserModel> collaborators,
    @Default(FormzSubmissionStatus.initial) FormzSubmissionStatus formStatus,
  }) = _GigSearchState;
}

extension SelectedGigSearch on GigSearchState {
  bool get allSelected {
    return results.every((result) => result.selected);
  }

  List<UserModel> get selectedResults {
    return results
        .where((result) => result.selected)
        .map((e) => e.user)
        .toList();
  }

  int get capacityRangeStart => capacityRange.start.round();
  int get capacityRangeEnd => capacityRange.end.round();
}

@JsonEnum()
enum DateRangeType {
  fixed,
  flexible,
}

@freezed
class SelectableResult with _$SelectableResult {
  const factory SelectableResult({
    required UserModel user,
    required bool selected,
  }) = _SelectableResult;
}
